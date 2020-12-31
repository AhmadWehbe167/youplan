import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:youplan/Authenticate_Screens/Auth_Services/RefactoredWidgets_Functions.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/services/ConnectionCheck.dart';

class PhoneLogInPage extends StatefulWidget {
  final Function toggleView;
  const PhoneLogInPage({this.toggleView});
  @override
  _PhoneLogInPageState createState() => _PhoneLogInPageState();
}

class _PhoneLogInPageState extends State<PhoneLogInPage> {
  String phoneNumber;
  String smsCode;
  String userName;
  String fullName;
  bool loading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => widget.toggleView(AuthPageEnum.SignIn),
        child: Form(
          key: _formKey1,
          child: Scaffold(
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
                        widget.toggleView(AuthPageEnum.SignIn);
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
                              image: AssetImage('images/LogIn.png'),
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
                    height: height * 0.2,
                  ), //10%
                  Padding(
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
                          borderRadius: new BorderRadius.circular(height / 50),
                          borderSide: new BorderSide(
                            color: navy,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
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
                          if (_formKey1.currentState.validate()) {
                            bool isConnected = await checkConnection();
                            if (isConnected) {
                              setState(() {
                                loading = true;
                              });

                              final HttpsCallable callable = FirebaseFunctions
                                  .instance
                                  .httpsCallable('checkIfPhoneExists');
                              dynamic resp =
                                  await callable.call({'phone': phoneNumber});
                              if (resp.data) {
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: phoneNumber,
                                  timeout: const Duration(seconds: 60),
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) async {
                                    Navigator.pop(context);

                                    //User with phone number already exists
                                    await FirebaseAuth.instance
                                        .signInWithCredential(credential)
                                        .catchError((onError) {
                                      print(onError.toString());
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
                                    });
                                    await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => WillPopScope(
                                        onWillPop: () async => false,
                                        child: AlertDialog(
                                          title: Text("Enter Code"),
                                          content: TextField(
                                            decoration: InputDecoration(
                                                labelText: "Code"),
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
                                                      PhoneAuthProvider
                                                          .credential(
                                                              verificationId:
                                                                  verificationId,
                                                              smsCode: smsCode);
                                                  // Sign the user in (or link) with the credential
                                                  Navigator.pop(context);
                                                  await FirebaseAuth.instance
                                                      .signInWithCredential(
                                                          phoneAuthCredential)
                                                      .catchError((onError) {
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
                                      ),
                                    );
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
                              } else {
                                setState(() {
                                  loading = false;
                                });
                                await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    title: Text("Not Registered!"),
                                    content: Text(
                                        "There is no account with this phone number. "
                                        "So please Sign Up for an account first!"),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("OK")),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              final SnackBar snackbar = SnackBar(
                                content: Text(
                                    "Check your internet connection and try again"),
                              );
                              _scaffoldKey.currentState.showSnackBar(snackbar);
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
                          widget.toggleView(AuthPageEnum.SignIn);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
