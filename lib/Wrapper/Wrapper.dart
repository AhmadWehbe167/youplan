import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Authenticate_Screens/Authenticate_Wrapper.dart';
import 'package:youplan/Main_Layout/Main_Layout.dart';
import 'package:youplan/Model/User.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Muser>(context);
    if (user != null) {
      print("User verification value is: ${user.isEmailVerified}");
    }
    if (user != null && user.isEmailVerified) {
      return MainPageLayout(userId: user.uid);
    } else {
      return Authentication();
    }
  }
}
