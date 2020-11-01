import 'package:flutter/material.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';

class AuthBackground extends StatefulWidget {
  @override
  _AuthBackgroundState createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground> {
  @override
  Widget build(BuildContext context) {
    // final double height = MediaQuery.of(context).size.height;
    // final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: lightNavy,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          AuthWavyHeader(),
//          Transform.translate(
//            offset: Offset(0, height / 3.2),
//            child: FittedBox(
//              fit: BoxFit.contain,
//              child: Text(
//                'Create an account to get started',
//                style: TextStyle(
//                  color: Colors.white,
//                  fontSize: height / 47,
//                ),
//              ),
//            ),
//          ),
//          MyImage(
//            imageName: 'orangeStandingMan',
//            myHeight: height / 3.2,
//            myWidth: width / 2.3,
//          ),
//          Transform.translate(
//            offset: Offset(0, height / 4),
//            child: MyImage(
//              imageName: 'WhiteSignUp',
//              myHeight: height / 15,
//              myWidth: width / 2.5,
//            ),
//          ),
        ],
      ),
    );
  }
}

class AuthWavyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AuthTopWaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: WhiteGradients,
              begin: Alignment.topLeft,
              end: Alignment.center),
        ),
        height: MediaQuery.of(context).size.height / 2.5,
      ),
    );
  }
}

class AuthTopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double _xScaling = size.width / 145;
    final double _yScaling = size.height / 190;
    path.lineTo(0.42463359 * _xScaling, 200.16935 * _yScaling);
    path.cubicTo(
      0.42463359 * _xScaling,
      140.16935 * _yScaling,
      0 * _xScaling,
      101.64877000000001 * _yScaling,
      210.86408 * _xScaling,
      0.4378373300000078 * _yScaling,
    );
    path.cubicTo(
      210.86408 * _xScaling,
      0.4378373300000078 * _yScaling,
      1.1762030000000152 * _xScaling,
      0.4378373400000078 * _yScaling,
      1.1762030000000152 * _xScaling,
      0.4378373400000078 * _yScaling,
    );
    path.cubicTo(
      1.1762030000000152 * _xScaling,
      0.4378373400000078 * _yScaling,
      0.42463359 * _xScaling,
      140.16935 * _yScaling,
      0.42463359 * _xScaling,
      140.16935 * _yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
