import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';

class MyTextField extends StatelessWidget {
  final String labelTitle;
  final Function validate;
  final TextInputType keyboard;
  final bool obsecure;
  final IconButton icon;
  final Function onChan;
  const MyTextField({
    Key key,
    this.labelTitle,
    this.validate,
    this.keyboard,
    this.obsecure,
    this.icon,
    this.onChan,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
      child: Container(
        child: TextFormField(
          style: TextStyle(
              color: navy, letterSpacing: 0.5, fontWeight: FontWeight.bold),
          obscureText: obsecure,
          decoration: new InputDecoration(
            errorStyle: TextStyle(fontWeight: FontWeight.bold),
            hintText: labelTitle,
            hintStyle: TextStyle(fontWeight: FontWeight.normal),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: icon,
            isDense: true,
            fillColor: Colors.white,
            filled: true,
            labelStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
            enabledBorder: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 2,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  color: navy,
                  width: 2,
                )),
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(15.0),
              borderSide: new BorderSide(),
            ),
          ),
          validator: validate,
          keyboardType: keyboard,
          onChanged: onChan,
        ),
      ),
    );
  }
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

bool checkTextNumbers(String value) {
  for (int i = 0; i < value.length; i++) {
    if (!value[i].contains(RegExp('[a-zA-Z0-9_-]'))) {
      return true;
    }
  }
  return false;
}

bool checkText(String value) {
  for (int i = 0; i < value.length; i++) {
    if (!value[i].contains(RegExp('[ a-zA-Z]'))) {
      return true;
    }
  }
  return false;
}

bool checkTextWithSpace(String value) {
  for (int i = 0; i < value.length; i++) {
    if (!value[i].contains(RegExp('[ \'a-zA-Z0-9_-]'))) {
      return true;
    }
  }
  return false;
}
