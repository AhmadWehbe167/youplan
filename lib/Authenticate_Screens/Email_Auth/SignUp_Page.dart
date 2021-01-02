import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youplan/Authenticate_Screens/Auth_Services/RefactoredWidgets_Functions.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/services/ConnectionCheck.dart';
import 'package:youplan/services/auth.dart';
import 'package:youplan/shared/Shared_functions.dart';

class SignUpPage extends StatefulWidget {
  final Function toggleView;
  final AuthServices auth;
  final double height;
  final double width;
  const SignUpPage({
    this.toggleView,
    this.auth,
    this.height,
    this.width,
  });
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isObscure = true;
  String userName;
  String fullName;
  String email;
  String password;
  String confirmPassword;
  String userNameTakenError;
  String emailTakenError;
  dynamic result;
  TextEditingController userNameController;
  TextEditingController fullNameController;
  TextEditingController emailController;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.toggleView(AuthPageEnum.Welcome),
      child: Form(
        key: _formKey,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: lightNavy,
          body: ListView(
            controller: _scrollController,
            children: [
              Container(
                height: widget.height * 0.26,
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
                          height: widget.height * 0.05,
                          width: widget.width * 0.8,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Create an account and get started',
                              style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
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
                height: widget.height * 0.01,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    widget.width * 0.05,
                    widget.height / 100,
                    widget.width * 0.05,
                    widget.height / 100),
                child: AuthTextField(
                  controller: userNameController,
                  obscure: false,
                  labelTitle: 'UserName',
                  keyboard: TextInputType.emailAddress,
                  onChan: (val) {
                    setState(() {
                      userName = val;
                    });
                  },
                  validate: (String val) {
                    setState(() {
                      userNameController = TextEditingController();
                      val = cleanFromSpaces(val);
                      userNameController.text = val;
                      userName = val;
                    });
                    if (val.length == 0) {
                      return 'This is mandatory';
                    } else if (val.length < 3) {
                      return 'UserName should be at least 3 characters';
                    } else if (val.length > 27) {
                      return 'UserName should not be more than 27';
                    } else if (containsWhiteSpaces(val)) {
                      return 'White spaces not allowed';
                    } else if (checkTextNumbers(val)) {
                      return 'only characters & numbers';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              userNameTakenError != null
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: widget.height / 100),
                        child: Text(
                          '$userNameTakenError',
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.fromLTRB(widget.width * 0.05, 0,
                    widget.width * 0.05, widget.height / 100),
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
              Padding(
                padding: EdgeInsets.fromLTRB(widget.width * 0.05, 0,
                    widget.width * 0.05, widget.height / 100),
                child: AuthTextField(
                  controller: emailController,
                  obscure: false,
                  labelTitle: 'Email',
                  keyboard: TextInputType.emailAddress,
                  onChan: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  validate: (String val) {
                    setState(() {
                      emailController = TextEditingController();
                      val = cleanFromSpaces(val);
                      emailController.text = val;
                      email = val;
                    });
                    if (val.isEmpty) {
                      return 'This is mandatory';
                    } else if (validateEmail(val)) {
                      return 'Please Provide a valid email';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              emailTakenError != null
                  ? Padding(
                      padding: EdgeInsets.only(bottom: widget.height / 100),
                      child: Center(
                        child: Text(
                          '$emailTakenError',
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.fromLTRB(widget.width * 0.05, 0,
                    widget.width * 0.05, widget.height / 100),
                child: Container(
                  child: AuthTextField(
                    obscure: isObscure,
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
                      } else {
                        return null;
                      }
                    },
                    icon: IconButton(
                      padding: EdgeInsets.fromLTRB(0, 0, widget.width / 100, 0),
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: navy,
                        size: widget.height / 30,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(widget.width * 0.05, 0,
                    widget.width * 0.05, widget.height / 100),
                child: AuthTextField(
                  obscure: isObscure,
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
                                fontSize: widget.width / 28,
                                color: Colors.white)),
                        TextSpan(
                            text: 'terms and conditions',
                            style: TextStyle(
                              fontSize: widget.width / 28,
                              color: Orange,
                              fontWeight: FontWeight.bold,
                            ))
                      ]),
                    ),
                  )),
              Container(
                height: widget.height * 0.26,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        child: RaisedButton(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(widget.width / 15),
                              side: BorderSide(color: Orange)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              bool isConnected = await checkConnection();
                              if (isConnected) {
                                setState(() {
                                  isLoading = true;
                                });
                                // showDialog(
                                //     context: context,
                                //     barrierDismissible: false,
                                //     builder: (context) => Center(
                                //         child: CircularProgressIndicator()));

                                bool userNameIsAvailable = await AuthServices()
                                    .checkUserNameAvailability(userName)
                                    .catchError((e) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  final SnackBar snackbar = SnackBar(
                                    content: Text(e.message),
                                  );
                                  _scaffoldKey.currentState
                                      .showSnackBar(snackbar);
                                });

                                if (userNameIsAvailable != null &&
                                    !userNameIsAvailable) {
                                  setState(() {
                                    isLoading = false;
                                    userNameTakenError =
                                        'UserName is taken choose a different one';
                                    emailTakenError = null;
                                    // networkError = null;
                                  });
                                } else {
                                  await widget.auth
                                      .registerWithEmailAndPassword(
                                          email, password)
                                      .then((value) {
                                    widget.toggleView(AuthPageEnum.Verify,
                                        userName, fullName, password);
                                  }).catchError((error) {
                                    //TODO:: deal with signed up but not verified emails
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (error.code == "email-already-in-use") {
                                      setState(() {
                                        emailTakenError =
                                            'Email is taken choose a different one';
                                        userNameTakenError = null;
                                      });
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Sign Up Failed!"),
                                          content: Text(
                                            errorMessagesHandler(error),
                                          ),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("OK"))
                                          ],
                                        ),
                                      );
                                    }
                                  });
                                }
                              } else {
                                setState(() {
                                  userNameTakenError = null;
                                  emailTakenError = null;
                                });
                                final SnackBar snackbar = SnackBar(
                                  content: Text(
                                      "Check your internet connection and try again"),
                                );
                                _scaffoldKey.currentState
                                    .showSnackBar(snackbar);
                              }
                            }
                          },
                          textColor: Colors.white,
                          color: Orange,
                          padding: EdgeInsets.fromLTRB(
                              widget.width / 4,
                              widget.height / 100,
                              widget.width / 4,
                              widget.height / 100),
                          child: isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text('Sign Up',
                                  style: TextStyle(
                                    fontSize: widget.height / 30,
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
                                fontSize: widget.width / 22,
                                color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggleView(AuthPageEnum.SignIn);
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  fontSize: widget.width / 21,
                                  color: Orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: widget.width / 1.7,
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
                        padding: EdgeInsets.only(
                            top: widget.height * 0.02, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Opacity(
                                child: GestureDetector(
                                  onTap: () {
                                    widget
                                        .toggleView(AuthPageEnum.PhoneRegister);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'images/phone.png'))),
                                  ),
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
      ),
    );
  }
}
