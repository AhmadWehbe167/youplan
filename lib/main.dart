import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/Wrapper/Wrapper.dart';
import 'package:youplan/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthServices().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: Wrapper(),
      ),
    );
  }
}
