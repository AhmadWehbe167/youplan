import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youplan/Authenticate_Screens/Email_Auth/SignUp_Page.dart';
import 'package:youplan/Authenticate_Screens/Email_Auth/Sign_in_Page.dart';
import 'package:youplan/Authenticate_Screens/Email_Auth/Verification_page.dart';
import 'package:youplan/Authenticate_Screens/Phone_Auth/Phone_Register_Page.dart';
import 'package:youplan/Authenticate_Screens/Phone_Auth/Phone_SignIn_Page.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Welcome/WelcomePage.dart';
import 'package:youplan/services/auth.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  AuthPageEnum authPageEnum = AuthPageEnum.Welcome;
  String userName;
  String fullName;
  String password;

  void toggleView(AuthPageEnum value,
      [String thiUserName, String thisFullName, String thisPassword]) {
    setState(() {
      authPageEnum = value;
      userName = thiUserName;
      fullName = thisFullName;
      password = thisPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    if (authPageEnum == AuthPageEnum.SignIn) {
      return SignInPage(
        toggleView: toggleView,
        auth: AuthServices(auth: FirebaseAuth.instance),
        height: height,
        width: width,
      );
    } else if (authPageEnum == AuthPageEnum.Register) {
      return SignUpPage(
        toggleView: toggleView,
        auth: AuthServices(auth: FirebaseAuth.instance),
        height: height,
        width: width,
      );
    } else if (authPageEnum == AuthPageEnum.Welcome) {
      return WelcomePage(
        toggleView: toggleView,
      );
    } else if (authPageEnum == AuthPageEnum.Verify) {
      return VerificationPage(
        toggleView: toggleView,
        userName: userName,
        fullName: fullName,
        password: password,
      );
    } else if (authPageEnum == AuthPageEnum.PhoneRegister) {
      return PhoneRegisterPage(
        toggleView: toggleView,
      );
    } else if (authPageEnum == AuthPageEnum.PhoneLogIn) {
      return PhoneLogInPage(
        toggleView: toggleView,
      );
    }
    return Container();
  }
}
