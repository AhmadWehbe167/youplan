import 'package:flutter/material.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';

class AuthBackground extends StatefulWidget {
  @override
  _AuthBackgroundState createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myOrange,
      body: Column(
        children: <Widget>[AuthWavyHeader()],
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
