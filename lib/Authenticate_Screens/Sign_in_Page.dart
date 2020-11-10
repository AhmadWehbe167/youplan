import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youplan/Authenticate_Screens/Refactored.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/services/ConnectionCheck.dart';
import 'package:youplan/services/auth.dart';
import 'package:youplan/shared/Shared_functions.dart';
import 'package:youplan/shared/loading.dart';

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
  bool isObsecure = true;
  String email;
  String tempEmail;
  String password;
  bool loading = false;
  bool isConnected = true;

  getConnection() async {
    isConnected = await checkConnection();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   getConnection();
  // }

  @override
  void initState() {
    super.initState();
    getConnection();
  }

  @override
  Widget build(BuildContext context) {
    // final double height = MediaQuery.of(context).size.height;
    // final double width = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : Form(
            key: _formKey,
            child: Scaffold(
              key: _scaffoldKey,
              backgroundColor: lightNavy,
              body: ListView(
                children: [
                  SizedBox(
                    height: widget.height * 0.05,
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
                    height: widget.height * 0.05,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/LogIn.png'))),
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: widget.height * 0.06,
                  ),
                  Center(
                    child: Container(
                      width: widget.width * 0.9,
                      height: widget.height * 0.07,
                      child: AuthTextField(
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
                    ),
                  ),
                  SizedBox(
                    height: widget.height * 0.01,
                  ),
                  Center(
                    child: Container(
                      width: widget.width * 0.9,
                      height: widget.height * 0.07,
                      child: AuthTextField(
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
                          padding: EdgeInsets.only(right: widget.width / 20),
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: Colors.black,
                            size: widget.width / 17,
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
                                  decoration:
                                      InputDecoration(labelText: "Email"),
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
                                            AuthServices(
                                                    auth: FirebaseAuth.instance)
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
                    height: widget.height * 0.06,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        if (isConnected) {
                          setState(() {
                            loading = true;
                          });
                          await widget.auth
                              .signInWithEmailAndPassword(email, password)
                              .catchError((err) {
                            showDialog(
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
                          setState(() {
                            loading = false;
                          });
                        } else {
                          await getConnection();
                          final SnackBar snackbar = SnackBar(
                            content: Text(
                                "'Check your internet connection and try again'"),
                          );
                          _scaffoldKey.currentState.showSnackBar(snackbar);
                        }
                      }
                    },
                    child: Center(
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(widget.width / 10),
                            side: BorderSide(color: logoGreen)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: logoGreen,
                            borderRadius:
                                BorderRadius.circular(widget.width / 10),
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
                    height: widget.height * 0.05,
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
                    height: widget.height * 0.05,
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
          );
  }
}
