import 'package:flutter/material.dart';
import 'package:youplan/Authenticate_Screens/Register_Page.dart';
import 'package:youplan/Authenticate_Screens/Sign_in_Page.dart';
import 'package:youplan/Authenticate_Screens/Welcome/WelcomePage.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  AuthPageEnum authPageEnum = AuthPageEnum.Welcome;

  void toggleView(AuthPageEnum value) {
    setState(() {
      authPageEnum = value;
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
    }
    return Container();
  }
}
