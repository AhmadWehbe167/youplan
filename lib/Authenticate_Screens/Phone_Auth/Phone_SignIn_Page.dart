import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/shared/loading.dart';

class PhoneLogInPage extends StatefulWidget {
  final Function toggleView;
  const PhoneLogInPage({this.toggleView});
  @override
  _PhoneLogInPageState createState() => _PhoneLogInPageState();
}

class _PhoneLogInPageState extends State<PhoneLogInPage> {
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
                    children: [
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
                                Navigator.pop(context);
                                _scaffoldKey.currentState
                                    .showSnackBar(snackBar);
                                setState(() {
                                  loading = true;
                                });
                                await FirebaseAuth.instance
                                    .signInWithCredential(credential)
                                    .catchError((onError) {
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
                                      "An Error occurred please try again!",
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
                                            Navigator.pop(context);
                                            // Sign the user in (or link) with the credential
                                            setState(() {
                                              loading = true;
                                            });
                                            await FirebaseAuth.instance
                                                .signInWithCredential(
                                                    phoneAuthCredential)
                                                .catchError((onError) {
                                              setState(() {
                                                loading = false;
                                              });
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
                          color: Colors.green,
                          onPressed: () {
                            widget.toggleView(AuthPageEnum.SignIn);
                          },
                          child: Text(
                            "Back",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
