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

class SignInPage extends StatefulWidget {
  final Function toggleView;
  const SignInPage({this.toggleView});
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  bool isObsecure = true;
  String email;
  String password;
  bool loading = false;
  String error;
  String networkError;
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
                        height: 25,
                      ),
                      MyImage(
                        imageName: 'RoundMan',
                        myHeight: 130,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      MyImage(
                        imageName: 'LogIn',
                        myHeight: 30,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(
                          'Welcome Back! Sign in to Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
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
                      error != null
                          ? Center(
                              child: Text(
                                '$error',
                                style: TextStyle(
                                    color: Colors.red[800],
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          : Container(),
                      MyTextField(
                        obsecure: false,
                        labelTitle: 'Email',
                        keyboard: TextInputType.emailAddress,
                        onChan: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        validate: (val) {
                          if (val.isEmpty) {
                            return 'This is mandatory';
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
                      GestureDetector(
                        onTap: () {
                          //TODO:add get password functionality
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              'Forgot your password?',
                              style: TextStyle(
                                  color: navy,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: RaisedButton(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: lightNavy)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              if (isConnected) {
                                try {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password);
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error =
                                          'Check email and password and try again';
                                      networkError = null;
                                    });
                                  }
                                } catch (e) {
                                  print(e.toString());
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              } else {
                                networkError =
                                    'Check your internet connection and try again';
                                error = null;
                                loading = false;
                              }
                            }
                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.fromLTRB(90, 10, 90, 10),
                          color: lightNavy,
                          child: const Text('Log In',
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
                            'Don\'t have an account? ',
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggleView(AuthPageEnum.Register);
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: navy,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
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
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
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
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
