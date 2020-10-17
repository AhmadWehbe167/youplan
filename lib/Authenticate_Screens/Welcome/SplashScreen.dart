import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:youplan/Wrapper/Wrapper.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      image: Image.asset(
        "images/Logo.png",
        fit: BoxFit.contain,
      ),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      onClick: () => print("flutter"),
      loaderColor: Colors.green,
      navigateAfterSeconds: Wrapper(),
    );
  }
}
