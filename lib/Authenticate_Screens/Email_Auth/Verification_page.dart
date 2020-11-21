import 'package:firebase_auth/firebase_auth.dart';
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
    return loading
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 300,
                    width: 280,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      alignment: Alignment.bottomCenter,
                      image: AssetImage('images/verification.png'),
                    )),
                  ),
                  SizedBox(
                    height: 100,
                  ),
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
                      },
                      child: Text("Continue")),
                ],
              ),
            ),
          );
  }
}
