import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:youplan/Authenticate_Screens/Auth_Services/RefactoredWidgets_Functions.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/services/ConnectionCheck.dart';
import 'package:youplan/services/auth.dart';
import 'package:youplan/shared/Shared_functions.dart';

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
  String userNameTakenError;
  bool codeSent = false;
  bool loading = false;
  String verificationID;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey1 = GlobalKey<FormState>();
  TextEditingController fullNameController;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => widget.toggleView(AuthPageEnum.Register),
      child: Form(
        key: _formKey1,
        child: Scaffold(
          //4%
          backgroundColor: lightNavy,
          key: _scaffoldKey,
          body: Center(
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      widget.toggleView(AuthPageEnum.Register);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  height: height * 0.26,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('images/orangeStandingMan.png'),
                          )),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('images/WhiteSignUp.png'),
                          )),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            height: height * 0.03,
                            width: width * 0.8,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'With Your Phone Number',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ), //26%
                SizedBox(
                  height: height * 0.08,
                ), //10%
                codeSent
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.fromLTRB(width * 0.05, height / 100,
                            width * 0.05, height / 100),
                        child: AuthTextField(
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
                      ),
                userNameTakenError != null
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: height / 100),
                          child: Text(
                            '$userNameTakenError',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Container(),
                codeSent
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.fromLTRB(
                            width * 0.05, 0, width * 0.05, height / 100),
                        child: AuthTextField(
                          controller: fullNameController,
                          obscure: false,
                          labelTitle: 'Full Name',
                          keyboard: TextInputType.emailAddress,
                          onChan: (val) {
                            setState(() {
                              fullName = val;
                            });
                          },
                          validate: (String val) {
                            setState(() {
                              fullNameController = TextEditingController();
                              val = cleanFromSpaces(val);
                              fullNameController.text = val;
                              fullName = val;
                            });
                            if (val.length == 0) {
                              return 'This is mandatory';
                            } else if (val.length < 4) {
                              return 'Name should be at least 4 characters';
                            } else if (val.length > 27) {
                              return 'Name should not be more than 27';
                            } else if (checkText(val)) {
                              return 'use only characters';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                codeSent
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(
                            width * 0.05, 0, width * 0.05, height / 100),
                        child: AuthTextField(
                          labelTitle: "Code",
                          validate: (val) {
                            if (val.length != 0) {
                              return 'Code is 6 digits long';
                            } else if (!isNumeric(val)) {
                              return 'Code is only numbers';
                            } else {
                              return null;
                            }
                          },
                          obscure: false,
                          keyboard: TextInputType.phone,
                          onChan: (val) {
                            smsCode = val;
                          },
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.fromLTRB(
                            width * 0.05, 0, width * 0.05, height / 100),
                        child: IntlPhoneField(
                          autoValidate: false,
                          keyboardType: TextInputType.phone,
                          onChanged: (val) {
                            setState(() {
                              phoneNumber = val.completeNumber;
                            });
                          },
                          validator: (String val) {
                            if (val.length == 0) {
                              return 'This is mandatory';
                            } else if (val.length < 7) {
                              return 'should be at least 7 digits';
                            } else if (val.length > 15) {
                              return 'should not be more than 15 digits';
                            } else if (!isNumeric(val)) {
                              return 'only numbers allowed';
                            } else {
                              return null;
                            }
                          },
                          countryCodeTextColor: Colors.grey[700],
                          dropDownArrowColor: Colors.grey[700],
                          initialCountryCode: "LB",
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(height / 50),
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                              fontSize: height * 0.018,
                            ),
                            hintText: "Phone Number",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: width * 0.05,
                            ),
                            suffixIcon: null,
                            isDense: true,
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    new BorderRadius.circular(height / 50),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    new BorderRadius.circular(height / 50),
                                borderSide: BorderSide(
                                  color: navy,
                                  width: 2,
                                )),
                            border: new OutlineInputBorder(
                              borderRadius:
                                  new BorderRadius.circular(height / 50),
                              borderSide: new BorderSide(
                                color: navy,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                codeSent
                    ? Center(
                        child: Text(
                          "Enter the code you received\n"
                          "through an SMS please",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: width * 0.042,
                            letterSpacing: 0.5,
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          "You will receive a 6 digits code through\n"
                          "a SMS to verify your phone number.",
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: width * 0.042,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                SizedBox(
                  height: height * 0.08,
                ), //10%
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      width * 0.05, 0, width * 0.05, height / 100),
                  child: Container(
                    height: height * 0.06,
                    child: RaisedButton(
                      elevation: 6,
                      color: Color(0xFFFD8853),
                      child: loading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width * 0.05,
                              ),
                            ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () async {
                        if (codeSent) {
                          PhoneAuthCredential phoneAuthCredential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationID,
                                  smsCode: smsCode);
                          // Sign the user in (or link) with the credential
                          setState(() {
                            loading = true;
                          });
                          await FirebaseAuth.instance
                              .signInWithCredential(phoneAuthCredential)
                              .then((value) async {
                            await AuthServices()
                                .initUser(userName, fullName,
                                    FirebaseAuth.instance.currentUser.uid)
                                .then((value) async {});
                          }).catchError((error) {
                            final SnackBar snackBar = SnackBar(
                              content: Text(
                                "An Error Occurred Please Try Again!",
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                            _scaffoldKey.currentState.showSnackBar(snackBar);
                          });
                        } else {
                          if (_formKey1.currentState.validate()) {
                            bool isConnected = await checkConnection();
                            setState(() {
                              userNameTakenError = null;
                            });
                            if (isConnected) {
                              setState(() {
                                loading = true;
                              });

                              bool userNameIsAvailable = await AuthServices()
                                  .checkUserNameAvailability(userName)
                                  .catchError((e) {
                                setState(() {
                                  loading = false;
                                });
                                final SnackBar snackbar = SnackBar(
                                  content: Text(errorMessagesHandler(e)),
                                );
                                _scaffoldKey.currentState
                                    .showSnackBar(snackbar);
                              });

                              if (userNameIsAvailable != null &&
                                  !userNameIsAvailable) {
                                setState(() {
                                  loading = false;
                                  userNameTakenError =
                                      'UserName is taken choose a different one';
                                });
                              } else {
                                final HttpsCallable callable = FirebaseFunctions
                                    .instance
                                    .httpsCallable('checkIfPhoneExists');
                                dynamic resp =
                                    await callable.call({'phone': phoneNumber});
                                if (resp.data) {
                                  setState(() {
                                    loading = false;
                                  });
                                  await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => AlertDialog(
                                      title: Text("Registered Already!"),
                                      content: Text(
                                          "An account with this phone number already exists. "
                                          "So please sign in!"),
                                      actions: [
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("OK")),
                                      ],
                                    ),
                                  );
                                } else {
                                  await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: phoneNumber,
                                    timeout: const Duration(seconds: 60),
                                    verificationCompleted:
                                        (PhoneAuthCredential credential) async {
                                      setState(() {
                                        loading = true;
                                      });
                                      await FirebaseAuth.instance
                                          .signInWithCredential(credential)
                                          .then((value) async {
                                        await AuthServices()
                                            .initUser(
                                                userName,
                                                fullName,
                                                FirebaseAuth
                                                    .instance.currentUser.uid)
                                            .then((value) async {});
                                      }).catchError((error) {
                                        final SnackBar snackBar = SnackBar(
                                          content: Text(
                                            "An Error Occurred Please Try Again!",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        );
                                        _scaffoldKey.currentState
                                            .showSnackBar(snackBar);
                                      });
                                    },
                                    verificationFailed:
                                        (FirebaseAuthException e) {
                                      setState(() {
                                        loading = false;
                                      });
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
                                      setState(() {
                                        loading = false;
                                        codeSent = true;
                                        verificationID = verificationId;
                                      });
                                    },
                                    codeAutoRetrievalTimeout:
                                        (String verificationId) async {
                                      setState(() {
                                        loading = false;
                                      });
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
                              }
                            } else {
                              setState(() {
                                userNameTakenError = null;
                              });
                              final SnackBar snackbar = SnackBar(
                                content: Text(
                                    "Check your internet connection and try again"),
                              );
                              _scaffoldKey.currentState.showSnackBar(snackbar);
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      width * 0.05, 0, width * 0.05, height / 100),
                  child: Container(
                    height: height * 0.06,
                    child: RaisedButton(
                      elevation: 6,
                      color: Color(0xFF0A91B0),
                      child: Text(
                        "Back",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.05,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        widget.toggleView(AuthPageEnum.Register);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
