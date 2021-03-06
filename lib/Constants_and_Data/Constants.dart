import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color turquoise = Color(0xff4adddd);
const Color logoGreen = Color(0xff77a93a);
const Color logoBlue = Color(0xff0071bd);
const Color logoViolet = Color(0xff814cce);
const Color Orange = Color(0xFFFD8256);
const Color navy = Color(0xFF00416A);
const Color lightNavy = Color(0xff005e74);
const List<Color> orangeGradients = [
  Color(0xFFFF9844),
  Color(0xFFFE8853),
  Color(0xFFFD7267),
];
const List<Color> WhiteGradients = [
  Colors.orange,
  Colors.amber,
  Colors.yellow,
];
const List<Color> aquaGradients = [navy, lightNavy];
const Color background = Color(0xFF043F6B);
const TextStyle kButtonText = TextStyle(color: Colors.white, fontSize: 25);
const TextStyle kLabelStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
);
final Color headerBottomColor = Color(0xFF095182);
const TextStyle kUnselectedLabelStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
enum AuthPageEnum {
  SignIn,
  Register,
  Welcome,
  Verify,
  PhoneRegister,
  PhoneLogIn
}

List planType = <String>[
  'Food & Drink',
  'Concerts & Shows',
  'Entertainment',
  'Cultural & Arts',
  'Other',
].map<DropdownMenuItem<String>>((String value) {
  return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
  );
}).toList();
