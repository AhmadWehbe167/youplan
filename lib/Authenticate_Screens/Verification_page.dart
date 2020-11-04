import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youplan/services/auth.dart';
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
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("One step ahead Verify your email"),
                  TextButton(
                    child: Text("Send Verification Email Again"),
                    onPressed: () async {
                      User currentUser = FirebaseAuth.instance.currentUser;
                      await currentUser.sendEmailVerification().then((value) {
                        final snackBar =
                            SnackBar(content: Text('Email verification sent!'));
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
                  TextButton(
                      onPressed: () async {
                        FirebaseAuth _auth = FirebaseAuth.instance;
                        if (_auth.currentUser != null) {
                          await _auth.currentUser.reload();
                        }
                        if (_auth.currentUser.emailVerified) {
                          setState(() {
                            loading = true;
                          });
                          String localEmail = _auth.currentUser.email;
                          String localUid = _auth.currentUser.uid;
                          await _auth.signOut();
                          if (widget.userName == null) {
                            print("UserName is null");
                          } else {
                            await AuthServices().initUser(
                                widget.userName, widget.fullName, localUid);
                          }
                          await _auth.signInWithEmailAndPassword(
                              email: localEmail, password: widget.password);
                          setState(() {
                            loading = false;
                          });
                          // widget.toggleView(AuthPageEnum.SignIn);
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
                      },
                      child: Text("Continue")),
                ],
              ),
            ),
          );
  }
}
