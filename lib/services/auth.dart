import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youplan/Model/User.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Muser _userFromFirebaseAuth(User user) {
    return user != null
        ? Muser(
            uid: user.uid,
            isEmailVerified: user.emailVerified,
            reload: user.reload)
        : null;
  }

  Stream<Muser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseAuth);
  }

  Future registerWithEmailAndPassword(
    BuildContext context,
    String userName,
    String fullName,
    String email,
    String password,
  ) async {
    User user;
    // UserCredential result =
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      if (!value.user.emailVerified) {
        await value.user.sendEmailVerification();
      }
      user = value.user;
    }).catchError((err) {
      user = null;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text(err.message),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"))
          ],
        ),
      );
    }).whenComplete(() {
      if (user != null) {
        return user;
      } else {
        return null;
      }
    });
  }

  Future signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential result = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .catchError((err) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text(err.message),
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
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future checkUserNameAvailability(String userName) async {
    DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('userNames')
        .doc(userName.toUpperCase())
        .get()
        .catchError((err) {});
    if (querySnapshot.exists) {
      return false;
    } else {
      return true;
    }
  }
}
