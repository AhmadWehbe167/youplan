import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youplan/Authenticate_Screens/AuthBackground.dart';
import 'package:youplan/Authenticate_Screens/Refactored.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/services/ConnectionCheck.dart';
import 'package:youplan/services/auth.dart';
import 'package:youplan/shared/Shared_Widgets.dart';
import 'package:youplan/shared/loading.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;
  const RegisterPage({this.toggleView});
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  bool isObsecure = true;
  String userName;
  String fullName;
  String email;
  String password;
  bool loading = false;
  String userNameTakenError;
  String networkError;
  String emailTakenError;
  dynamic result;
  bool isConnected = true;

  getConnection() async {
    isConnected = await checkConnection();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getConnection();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                AuthBackground(),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: ListView(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      MyImage(
                        imageName: 'standingMan',
                        myHeight: 130,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MyImage(
                        imageName: 'WhiteSignUp',
                        myHeight: 30,
                      ),
                      Center(
                        child: Text(
                          'Create an account to get started',
                          style: TextStyle(
//                            color: Color(0xfff5b8da),
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      networkError != null
                          ? Center(
                              child: Text(
                                '$networkError',
                                style: TextStyle(
                                    color: Colors.red[800],
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Container(),
                      emailTakenError != null
                          ? Center(
                              child: Text(
                                '$emailTakenError',
                                style: TextStyle(
                                    color: Colors.red[800],
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Container(),
                      MyTextField(
                        obsecure: false,
                        labelTitle: 'UserName',
                        keyboard: TextInputType.emailAddress,
                        onChan: (val) {
                          setState(() {
                            userName = val;
                          });
                        },
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
                      ),
                      userNameTakenError != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(
                                'UserName is taken choose a different one',
                                style: TextStyle(color: Colors.red[800]),
                              ),
                            )
                          : Container(),
                      MyTextField(
                        obsecure: false,
                        labelTitle: 'Full Name',
                        keyboard: TextInputType.emailAddress,
                        onChan: (val) {
                          setState(() {
                            fullName = val;
                          });
                        },
                        validate: (String val) {
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
                      MyTextField(
                        obsecure: false,
                        labelTitle: 'Email',
                        keyboard: TextInputType.emailAddress,
                        onChan: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        validate: (String val) {
                          if (val.isEmpty) {
                            return 'This is mandatory';
                          } else if (val[val.length - 1] == ' ') {
                            return 'Check if last letter is white space';
                          } else if (!validateEmail(val)) {
                            return 'Please Provide a valid email';
                          } else {
                            return null;
                          }
                        },
                      ),
                      MyTextField(
                        obsecure: isObsecure,
                        labelTitle: 'Password',
                        keyboard: TextInputType.emailAddress,
                        onChan: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        validate: (val) {
                          if (val.length == 0) {
                            return 'This is mandatory';
                          } else if (val.length < 6) {
                            return 'Password should be at least 6 characters';
                          } else if (val.length > 27) {
                            return 'Password should not be more than 27';
                          } else if (val[val.length - 1] == ' ') {
                            return 'Check if last letter is white space';
                          } else if (containsWhiteSpaces(val)) {
                            return 'you can\'t have white spaces in password';
                          } else if (!checkAlphaNumericPass(val)) {
                            return 'Password should contain both letters and numbers';
                          } else {
                            return null;
                          }
                        },
                        icon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: Colors.black,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              isObsecure = !isObsecure;
                            });
                          },
                        ),
                      ),
                      Center(
                          child: RichText(
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: 'By signing up you agree to the ',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                          TextSpan(
                              text: 'terms and conditions',
                              style: TextStyle(
                                fontSize: 12,
                                color: navy,
                                fontWeight: FontWeight.bold,
                              ))
                        ]),
                      )),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: RaisedButton(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: lightNavy)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              bool isConnected = await checkConnection();
                              if (isConnected) {
                                try {
                                  setState(() {
                                    loading = true;
                                  });
                                  print('I\'m connected');
                                  bool isAvailable = await AuthServices()
                                      .checkUserNameAvailability(userName);
                                  print(
                                      'checking username did complete successfully');
                                  if (!isAvailable) {
                                    setState(() {
                                      loading = false;
                                      userNameTakenError =
                                          'UserName is taken choose a different one';
                                      emailTakenError = null;
                                      networkError = null;
                                    });
                                  } else {
                                    print('UserName is not taken');
                                    result = await _auth
                                        .registerWithEmailAndPassword(
                                      userName,
                                      fullName,
                                      email,
                                      password,
                                    );
                                    print(
                                        'Registering did complete successfully');
                                    if (result == null) {
                                      setState(() {
                                        loading = false;
                                        emailTakenError =
                                            'this email is already taken';
                                        userNameTakenError = null;
                                        networkError = null;
                                      });
                                    }
                                  }
                                } on PlatformException catch (a) {
                                  setState(() {
                                    loading = false;
                                    networkError =
                                        'An Error occured please try again';
                                    userNameTakenError = null;
                                    emailTakenError = null;
                                  });
                                }
                              } else {
                                setState(() {
                                  networkError =
                                      'Check your internet connection and try again';
                                  userNameTakenError = null;
                                  emailTakenError = null;
                                  loading = false;
                                });
                              }
                            }
                          },
                          textColor: Colors.white,
                          color: lightNavy,
                          padding: const EdgeInsets.fromLTRB(80, 10, 80, 10),
                          child: const Text('Sign Up',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggleView(AuthPageEnum.SignIn);
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  fontSize: 17,
//                                  color: Color(0xff063e4f),
                                  color: navy,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                          child: Text(
                            '---- Or Continue With ----',
                            style: TextStyle(
                              color: lightNavy,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Opacity(
                              child: MyImage(
                                myHeight: 40,
                                imageName: 'Facebook',
                              ),
                              opacity: 0.85,
                            ),
                            Opacity(
                              child: MyImage(
                                myHeight: 40,
                                imageName: 'google',
                              ),
                              opacity: 0.85,
                            ),
                            Opacity(
                              child: MyImage(
                                myHeight: 40,
                                imageName: 'phone',
                              ),
                              opacity: 0.85,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
