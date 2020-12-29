import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youplan/Authenticate_Screens/Auth_Services/RefactoredWidgets_Functions.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/services/ConnectionCheck.dart';
import 'package:youplan/services/auth.dart';
import 'package:youplan/shared/Shared_functions.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;
  final AuthServices auth;
  final double height;
  final double width;
  const SignInPage({this.toggleView, this.auth, this.height, this.width});
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  String email;
  String tempEmail;
  String password;
  bool isConnected = true;
  TextEditingController passController;

  getConnection() async {
    isConnected = await checkConnection();
  }

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
            children: [
              SizedBox(
                height: widget.height * 0.03,
              ),
              Container(
                height: widget.height * 0.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/GreenRoundMan.png'),
                  ),
                ),
              ),
              Container(
                height: widget.height * 0.045,
                decoration: BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage('images/LogIn.png'))),
              ),
              Center(
                child: Container(
                  height: widget.height * 0.05,
                  width: widget.width * 0.8,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'Welcome Back! Sign in to Continue',
                      style: TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: widget.height * 0.08,
              ),
              Center(
                child: Container(
                  width: widget.width * 0.9,
                  child: AuthTextField(
                    obscure: false,
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
                ),
              ),
              SizedBox(
                height: widget.height * 0.01,
              ),
              Center(
                child: Container(
                  width: widget.width * 0.9,
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
              SizedBox(
                height: widget.height * 0.01,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Reset Password"),
                            content: TextField(
                              decoration: InputDecoration(labelText: "Email"),
                              onChanged: (String s) {
                                setState(() {
                                  tempEmail = s;
                                });
                              },
                            ),
                            actions: [
                              Row(
                                children: [
                                  FlatButton(
                                      onPressed: () {
                                        widget.auth
                                            .resetPassword(tempEmail)
                                            .then((value) {
                                          Navigator.pop(context);
                                          final snackBar = SnackBar(
                                              content: Text(
                                                  'Password Reset email has been sent successfully!'));
                                          _scaffoldKey.currentState
                                              .showSnackBar(snackBar);
                                        }).catchError((onError) {
                                          Navigator.pop(context);
                                          final snackBar = SnackBar(
                                              content: Text(
                                                  errorMessagesHandler(
                                                      onError)));
                                          _scaffoldKey.currentState
                                              .showSnackBar(snackBar);
                                        });
                                      },
                                      child: Text("Reset")),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel")),
                                ],
                              )
                            ],
                          ));
                },
                child: Center(
                  child: Container(
                    width: widget.width * 0.88,
                    height: widget.height * 0.025,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: logoGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: widget.height,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: widget.height * 0.08,
              ),
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState.validate()) {
                    await getConnection();
                    if (isConnected) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              Center(child: CircularProgressIndicator()));

                      await widget.auth
                          .signInWithEmailAndPassword(email, password)
                          .then((value) {
                        Navigator.pop(context);
                      }).catchError((err) async {
                        Navigator.pop(context);
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Log In Failed!"),
                            content: Text(errorMessagesHandler(err)),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("OK"))
                            ],
                          ),
                        );
                      });
                    } else {
                      await getConnection();
                      final SnackBar snackbar = SnackBar(
                        content: Text(
                            "Check your internet connection and try again!"),
                      );
                      _scaffoldKey.currentState.showSnackBar(snackbar);
                    }
                  }
                },
                child: Center(
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(widget.width / 10),
                        side: BorderSide(color: logoGreen)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: logoGreen,
                        borderRadius: BorderRadius.circular(widget.width / 10),
                      ),
                      padding: EdgeInsets.fromLTRB(
                          0, widget.height / 100, 0, widget.height / 100),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text('Log In',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )),
                      ),
                      height: widget.height * 0.06,
                      width: widget.width * 0.7,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: widget.height * 0.035,
                  width: widget.width * 0.65,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            widget.toggleView(AuthPageEnum.Register);
                          },
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: logoGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: widget.height * 0.03,
              ),
              Center(
                child: Container(
                  width: widget.width * 0.5,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '---- Or Continue With ----',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.height,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: widget.height * 0.04,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Opacity(
                        opacity: 0.85,
                        child: GestureDetector(
                          onTap: () {
                            widget.toggleView(AuthPageEnum.PhoneLogIn);
                          },
                          child: Container(
                            height: widget.height * 0.06,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/phone.png'),
                                    fit: BoxFit.contain)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
