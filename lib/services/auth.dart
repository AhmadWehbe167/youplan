import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/services/Friend_Requests_database.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseAuth(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseAuth);
  }

  Future registerWithEmailAndPassword(
    BuildContext context,
    String userName,
    String fullName,
    String email,
    String password,
  ) async {
    try {
      AuthResult result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
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
      FirebaseUser user = result.user;
      if (result != null) {
        await FRDatabaseService(uid: user.uid).initUser(userName, fullName);
        return _userFromFirebaseAuth(user);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseAuth(user);
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
    DocumentSnapshot querySnapshot = await Firestore.instance
        .collection('userNames')
        .document(userName.toUpperCase())
        .get()
        .catchError((err) {});
    if (querySnapshot.exists) {
      return false;
    } else {
      return true;
    }
  }
}
