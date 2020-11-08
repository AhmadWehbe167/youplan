import 'package:flutter/material.dart';

class SomethingWentWrong extends StatefulWidget {
  @override
  _SomethingWentWrongState createState() => _SomethingWentWrongState();
}

class _SomethingWentWrongState extends State<SomethingWentWrong> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Text(
        "Something went Wrong",
        style: TextStyle(fontSize: 40),
      )),
    );
  }
}
