import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youplan/Authenticate_Screens/Refactored.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/services/ConnectionCheck.dart';
import 'package:youplan/services/auth.dart';
import 'package:youplan/shared/loading.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;
  const RegisterPage({this.toggleView});
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  ScrollController _scrollController = ScrollController();
  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  bool isObsecure = true;
  String userName;
  String fullName;
  String email;
  String password;
  String confirmPassword;
  bool loading = false;
  String userNameTakenError;
  String networkError;
  String emailTakenError;
  dynamic result;

  AuthPageEnum authPageEnum;
  void toggleView(AuthPageEnum value) {
    setState(() {
      authPageEnum = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User>(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : Form(
            key: _formKey,
            child: Scaffold(
              backgroundColor: lightNavy,
              body: ListView(
                controller: _scrollController,
                children: [
                  Container(
                    height: height * 0.25,
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
                          child: Container(
                            width: width / 1.6,
                            child: FittedBox(
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                              child: Text(
                                'Create an account to get started',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  networkError != null
                      ? Center(
                          child: Text(
                            '$networkError',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: width / 24,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width * 0.05, height / 100, width * 0.05, height / 100),
                    child: AuthTextField(
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
                  ),
                  userNameTakenError != null
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: height / 100),
                            child: Text(
                              'UserName is taken choose a different one',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width * 0.05, 0, width * 0.05, height / 100),
                    child: AuthTextField(
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
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width * 0.05, 0, width * 0.05, height / 100),
                    child: AuthTextField(
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
                  ),
                  emailTakenError != null
                      ? Padding(
                          padding: EdgeInsets.only(bottom: height / 100),
                          child: Center(
                            child: Text(
                              '$emailTakenError',
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: width / 23,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width * 0.05, 0, width * 0.05, height / 100),
                    child: Container(
                      height: height * 0.07,
                      child: AuthTextField(
                        obsecure: isObsecure,
                        labelTitle: 'Password',
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
                          padding: EdgeInsets.fromLTRB(0, 0, width / 100, 0),
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: Colors.black,
                            size: height / 30,
                          ),
                          onPressed: () {
                            setState(() {
                              isObsecure = !isObsecure;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width * 0.05, 0, width * 0.05, height / 100),
                    child: AuthTextField(
                      obsecure: isObsecure,
                      labelTitle: 'Confirm Password',
                      onChan: (val) {
                        setState(() {
                          confirmPassword = val;
                        });
                      },
                      validate: (val) {
                        if (val != password) {
                          return 'Passwords don\'t match';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                                text: 'By signing up you agree to the ',
                                style: TextStyle(
                                    fontSize: width / 28, color: Colors.white)),
                            TextSpan(
                                text: 'terms and conditions',
                                style: TextStyle(
                                  fontSize: width / 28,
                                  color: myOrange,
                                  fontWeight: FontWeight.bold,
                                ))
                          ]),
                        ),
                      )),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    height: height * 0.27,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            child: RaisedButton(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(width / 15),
                                  side: BorderSide(color: myOrange)),
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
                                          context,
                                          userName,
                                          fullName,
                                          email,
                                          password,
                                        );
                                        setState(() {
                                          loading = false;
                                        });
                                        widget.toggleView(AuthPageEnum.Verify,
                                            userName, fullName, password);
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
                              color: myOrange,
                              padding: EdgeInsets.fromLTRB(width / 4,
                                  height / 100, width / 4, height / 100),
                              child: Text('Sign Up',
                                  style: TextStyle(
                                    fontSize: height / 30,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            alignment: Alignment.bottomCenter,
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                    fontSize: width / 22, color: Colors.white),
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.toggleView(AuthPageEnum.SignIn);
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontSize: width / 21,
                                      color: myOrange,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: width / 1.7,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                '---- Or Continue With ----',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: height * 0.02, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Opacity(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'images/phone.png'))),
                                    ),
                                    opacity: 0.9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
