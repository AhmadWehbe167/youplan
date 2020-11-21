import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/services/collections_references.dart';

class AuthServices {
  String userName = 'userName';
  String fullName = 'fullName';
  final FirebaseAuth auth;
  AuthServices({
    this.auth,
  });

  //the following two methods is to create a stream of user where
  // Wrapper can check if user is logged in or not
  Muser _userFromFirebaseAuth(User user) {
    return user != null
        ? Muser(
            uid: user.uid,
            isEmailVerified: user.emailVerified,
            reload: user.reload,
          )
        : null;
  }

  Stream<Muser> get userStream {
    return auth.authStateChanges().map(_userFromFirebaseAuth);
  }

  Future registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      if (!value.user.emailVerified) {
        await value.user.sendEmailVerification();
      }
    }).catchError((err) {
      throw err;
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e.message);
      print(e.code);
      throw e;
    }
  }

  Future signOut() async {
    try {
      return await auth.signOut();
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
        .catchError((err) {
      throw err;
    });
    if (querySnapshot.exists) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw (e);
    }
  }

  Future initUser(String userNameArg, String fullNameArg, String uid) async {
    try {
      await usersReference.doc(uid).set({
        '$userName': userNameArg,
        '$fullName': fullNameArg,
      });
      await FirebaseFirestore.instance.collection('Friends').doc(uid).set({
        'friends': [],
      });
      await plansReference.doc(uid).set({
        'plans': [],
      });
      await memoriesReference
          .doc(uid)
          .collection('categories')
          .doc('Food & Drink')
          .set({
        'plans': [],
      });
      await memoriesReference
          .doc(uid)
          .collection('categories')
          .doc('Concerts & Shows')
          .set({
        'plans': [],
      });
      await memoriesReference
          .doc(uid)
          .collection('categories')
          .doc('Entertainment')
          .set({
        'plans': [],
      });
      await memoriesReference
          .doc(uid)
          .collection('categories')
          .doc('Cultural & Arts')
          .set({
        'plans': [],
      });
      await memoriesReference
          .doc(uid)
          .collection('categories')
          .doc('Other')
          .set({
        'plans': [],
      });
      await planNamesReference.doc(uid).set({
        'Names': [],
      });
      await userNamesReference.doc(userNameArg.toUpperCase()).set({});
      return await requestsReference.doc(uid).set({
        'friends': [],
        'plans': [],
      });
    } catch (e) {
      throw e;
    }
  }

  // Future<void> signInWithPhoneNumber(
  //   String countryCode,
  //   String phoneNumber,
  //   GlobalKey<ScaffoldState> scaffoldKey,
  //   Function codeSentFunction,
  //   Function codeAutoRetrievalFunction,
  // ) async {}
}
