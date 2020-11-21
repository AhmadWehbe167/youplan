import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youplan/services/auth.dart';
import 'package:youplan/shared/Shared_functions.dart';
import 'package:youplan/shared/loading.dart';

class VerificationPage extends StatefulWidget {
  final Function toggleView;
  final String userName;
  final String fullName;
  final String password;
  VerificationPage(
      {this.userName, this.fullName, this.toggleView, this.password});
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            body: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.03,
                  ), //3%
                  Container(
                    height: height * 0.35,
                    width: width * 0.9,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      alignment: Alignment.bottomCenter,
                      image: AssetImage('images/verification.png'),
                    )),
                  ), //35%
                  SizedBox(
                    height: height * 0.1,
                  ), //10%
                  Container(
                    height: height * 0.05,
                    child: Text(
                      "Verify Your Email!",
                      style: TextStyle(
                        fontFamily: "NotoSansJP",
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.1,
                        color: Color(0xFF007D9A),
                      ),
                    ),
                  ), //5%
                  SizedBox(
                    height: height * 0.01,
                  ), //1%
                  Container(
                    height: height * 0.08,
                    child: Text(
                      "you will receive a verification email. Click\n"
                      " on the link inside and come back here to\n"
                      "Continue",
                      style: TextStyle(
                        letterSpacing: 0.8,
                        fontSize: width * 0.038,
                        color: Colors.blueGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ), //8%
                  SizedBox(
                    height: height * 0.1,
                  ), //10%
                  Container(
                    width: width * 0.8,
                    height: height * 0.06,
                    child: RaisedButton(
                        elevation: 6,
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.05,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Color(0xFFFE8753),
                        onPressed: () async {
                          FirebaseAuth _auth = FirebaseAuth.instance;
                          if (_auth.currentUser != null) {
                            await _auth.currentUser.reload();
                          }
                          if (_auth.currentUser.emailVerified) {
                            setState(() {
                              loading = true;
                            });
                            try {
                              String localEmail = _auth.currentUser.email;
                              String localUid = _auth.currentUser.uid;
                              // var credential = EmailAuthProvider.credential(
                              //     email: localEmail, password: widget.password);
                              // _auth.currentUser.linkWithCredential(credential);
                              await _auth.signOut();
                              await _auth
                                  .signInWithEmailAndPassword(
                                      email: localEmail,
                                      password: widget.password)
                                  .then((_) async {
                                await AuthServices()
                                    .initUser(widget.userName, widget.fullName,
                                        localUid)
                                    .catchError((err) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Operation Failed!"),
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
                              }).catchError((err) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Operation Failed!"),
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
                            } catch (e) {
                              final snackBar = SnackBar(
                                  content: Text(
                                      'An Error occurred please try again!'));
                              Scaffold.of(context).showSnackBar(snackBar);
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Verification Required"),
                                      content: Text(
                                          "Please Press on the link sent to your email "
                                          "to verify this account before continuing"),
                                      actions: [
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("OK"))
                                      ],
                                    ));
                          }
                        }),
                  ), //6%
                  SizedBox(
                    height: height * 0.01,
                  ), //1%
                  Container(
                    width: width * 0.8,
                    height: height * 0.06,
                    child: RaisedButton(
                      elevation: 6,
                      child: Text(
                        "Resend Verification Email",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.045,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Color(0xFF007A97),
                      onPressed: () async {
                        User currentUser = FirebaseAuth.instance.currentUser;
                        await currentUser.sendEmailVerification().then((value) {
                          final snackBar = SnackBar(
                              content: Text('Email verification sent!'));
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        }).catchError((onError) {
                          print(onError.toString());
                          final snackBar = SnackBar(
                              content: Text('Email verification Failed!'));
                          Scaffold.of(context).showSnackBar(snackBar);
                        }).whenComplete(() {
                          print("Process completed!");
                        });
                      },
                    ),
                  ), //6%
                  SizedBox(
                    height: height * 0.15,
                  ) //15%
                ],
              ),
            ),
          );
  }
}
