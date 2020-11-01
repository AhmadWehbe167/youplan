import 'package:flutter/material.dart';
import 'package:youplan/Authenticate_Screens/Register_Page.dart';
import 'package:youplan/Authenticate_Screens/Sign_in_Page.dart';
import 'package:youplan/Authenticate_Screens/Verification_page.dart';
import 'package:youplan/Authenticate_Screens/Welcome/WelcomePage.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';

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
    if (authPageEnum == AuthPageEnum.SignIn) {
      return SignInPage(
        toggleView: toggleView,
      );
    } else if (authPageEnum == AuthPageEnum.Register) {
      return RegisterPage(
        toggleView: toggleView,
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
    }
    return Container();
  }
}
