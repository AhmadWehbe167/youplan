import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Authenticate_Screens/Auth_Services/RefactoredWidgets_Functions.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/services/auth.dart';
import 'package:youplan/shared/loading.dart';

class PhoneRegisterPage extends StatefulWidget {
  final Function toggleView;
  const PhoneRegisterPage({this.toggleView});
  @override
  _PhoneRegisterPageState createState() => _PhoneRegisterPageState();
}

class _PhoneRegisterPageState extends State<PhoneRegisterPage> {
  String countryCode;
  String phoneNumber;
  String smsCode;
  String userName;
  String fullName;
  String buttonText = "Continue";
  bool loading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Muser>(context);
    return loading
        ? Loading()
        : Form(
            key: _formKey1,
            child: Scaffold(
              key: _scaffoldKey,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AuthTextField(
                        labelTitle: "UserName",
                        keyboard: TextInputType.text,
                        validate: (String val) {
                          if (val.length == 0) {
                            return 'This is mandatory';
                          } else if (val.length < 3) {
                            return 'UserName should be at least 3 characters';
                          } else if (val.length > 27) {
                            return 'UserName should not be more than 27';
                          } else if (val[val.length - 1] == ' ') {
                            return 'Check if last letter is white space';
                          } else if (checkTextNumbers(val)) {
                            return 'no spaces and only characters, numbers, underscore';
                          } else {
                            return null;
                          }
                        },
                        onChan: (val) {
                          setState(() {
                            userName = val;
                          });
                        },
                        obscure: false,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Full Name",
                        ),
                        onChanged: (name) {
                          setState(() {
                            fullName = name;
                          });
                        },
                        validator: (String val) {
                          if (val.length == 0) {
                            return 'This is mandatory';
                          } else if (val.length < 4) {
                            return 'Name should be at least 4 characters';
                          } else if (val.length > 27) {
                            return 'Name should not be more than 27';
                          } else if (val[val.length - 1] == ' ') {
                            return 'Check if last letter is white space';
                          } else if (checkText(val)) {
                            return 'use only characters';
                          } else if (consecutiveWhiteSpaces(val)) {
                            return 'you can\'t have two white spaces consecutively';
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Country Code",
                        ),
                        onChanged: (code) {
                          setState(() {
                            countryCode = code;
                          });
                        },
                        validator: (String val) {
                          if (val.length > 3 || val.length == 0) {
                            return 'Put valid Country Code';
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                        ),
                        onChanged: (String s) {
                          setState(() {
                            phoneNumber = s;
                          });
                        },
                        validator: (String val) {
                          if (val.length < 5 || val.length > 13) {
                            return 'Put valid Phone number';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      FlatButton(
                        onPressed: () async {
                          if (_formKey1.currentState.validate()) {
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: "+" + countryCode + phoneNumber,
                              timeout: const Duration(seconds: 60),
                              verificationCompleted:
                                  (PhoneAuthCredential credential) async {
                                final SnackBar snackBar = SnackBar(
                                  content: Text(
                                    "The SMS Message has been received successfully!",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                );
                                _scaffoldKey.currentState
                                    .showSnackBar(snackBar);
                                setState(() {
                                  loading = true;
                                });
                                await FirebaseAuth.instance
                                    .signInWithCredential(credential)
                                    .then((value) async {
                                  await AuthServices().initUser(
                                      userName,
                                      fullName,
                                      FirebaseAuth.instance.currentUser.uid);
                                }).catchError((onError) {
                                  print(onError.toString());
                                  setState(() {
                                    loading = false;
                                  });
                                });
                              },
                              verificationFailed: (FirebaseAuthException e) {
                                if (e.code == 'invalid-phone-number') {
                                  final SnackBar snackBar = SnackBar(
                                    content: Text(
                                      "The provided phone number is not valid!",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                } else {
                                  final SnackBar snackBar = SnackBar(
                                    content: Text(
                                      "An Error occurred please try again! ${e.message}",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackBar);
                                }
                              },
                              codeSent: (String verificationId,
                                  int resendToken) async {
                                // Update the UI - wait for the user to enter the SMS code
                                await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    title: Text("Enter Code"),
                                    content: TextField(
                                      decoration:
                                          InputDecoration(labelText: "Code"),
                                      keyboardType: TextInputType.phone,
                                      onChanged: (String code) {
                                        smsCode = code;
                                      },
                                    ),
                                    actions: [
                                      FlatButton(
                                          onPressed: () async {
                                            // Create a PhoneAuthCredential with the code
                                            PhoneAuthCredential
                                                phoneAuthCredential =
                                                PhoneAuthProvider.credential(
                                                    verificationId:
                                                        verificationId,
                                                    smsCode: smsCode);
                                            // Sign the user in (or link) with the credential
                                            Navigator.pop(context);
                                            setState(() {
                                              loading = true;
                                            });
                                            await FirebaseAuth.instance
                                                .signInWithCredential(
                                                    phoneAuthCredential)
                                                .then((value) async {
                                              await AuthServices().initUser(
                                                  userName,
                                                  fullName,
                                                  FirebaseAuth.instance
                                                      .currentUser.uid);
                                            }).catchError((onError) {
                                              setState(() {
                                                loading = false;
                                              });
                                              print(onError.toString());
                                            });
                                          },
                                          child: Text("Done")),
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancel")),
                                    ],
                                  ),
                                );
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) async {
                                await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    title: Text("Error!"),
                                    content: Text(
                                        "An Error occurred. Please Try Again!"),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("OK")),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          buttonText,
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
                      ),
                      FlatButton(
                          onPressed: () {
                            widget.toggleView(AuthPageEnum.Register);
                          },
                          child: Text("Back"))
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
