import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';

class AuthTextField extends StatelessWidget {
  final String labelTitle;
  final Function validate;
  final TextInputType keyboard;
  final bool obscure;
  final IconButton icon;
  final Function onChan;
  final TextEditingController controller;
  const AuthTextField({
    Key key,
    this.labelTitle,
    this.validate,
    this.keyboard,
    this.obscure,
    this.icon,
    this.onChan,
    this.controller,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      controller: controller,
      style: TextStyle(
        color: navy,
        letterSpacing: 0.3,
        // fontWeight: FontWeight.bold,
        fontSize: height * 0.025,
      ),
      obscureText: obscure,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(height / 50),
        errorStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.redAccent,
          fontSize: height * 0.018,
        ),
        hintText: labelTitle,
        hintStyle: TextStyle(
          fontWeight: FontWeight.normal,
        ),
        suffixIcon: icon,
        isDense: true,
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(height / 50),
            borderSide: BorderSide(
              color: Colors.white,
              width: 2,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(height / 50),
            borderSide: BorderSide(
              color: navy,
              width: 2,
            )),
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(height / 50),
          borderSide: new BorderSide(
            color: navy,
            width: 2,
          ),
        ),
      ),
      validator: validate,
      keyboardType: keyboard,
      onChanged: onChan,
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

// bool checkAlphaNumericPass(String value) {
//   bool alpha = false;
//   bool numeric = false;
//   for (int i = 0; i < value.length; i++) {
//     if (value[i].contains(RegExp('[a-zA-Z]')) && alpha == false) {
//       alpha = true;
//     } else if (value[i].contains(RegExp('[0-9]')) && numeric == false) {
//       numeric = true;
//     } else if (value[i].contains(RegExp('[a-zA-Z]')) && numeric == true) {
//       return true;
//     } else if (value[i].contains(RegExp('[0-9]')) && alpha == true) {
//       return true;
//     }
//   }
//   return false;
// }

bool containsWhiteSpaces(String value) {
  for (int i = 0; i < value.length; i++) {
    if (value[i].contains(RegExp(' '))) {
      return true;
    }
  }
  return false;
}

bool consecutiveWhiteSpaces(String value) {
  for (int i = 0; i < value.length - 1; i++) {
    if (value[i].contains(RegExp(' '))) {
      if (value[i + 1].contains(RegExp(' '))) {
        return true;
      }
    }
  }
  return false;
}

String cleanFromSpaces(String value) {
  while (consecutiveWhiteSpaces(value)) {
    value = value.replaceAll("  ", " ");
  }
  if (value.length > 1 && value[value.length - 1] == ' ') {
    value = value.substring(0, value.length - 1);
  }
  if (value.length > 1 && value[0] == ' ') {
    value = value.substring(1, value.length);
  }
  return value;
}
