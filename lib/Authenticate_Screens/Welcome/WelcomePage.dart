import 'package:flutter/material.dart';
import 'package:youplan/Authenticate_Screens/Welcome/WaversWidgets.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';

class WelcomePage extends StatefulWidget {
  final Function toggleView;
  const WelcomePage({this.toggleView});
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              WavyHeader(
                height: height,
              ),
              Container(
                height: height / 3,
                width: width / 1.9,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  alignment: Alignment.bottomCenter,
                  image: AssetImage('images/Logo.png'),
                )),
              )
            ],
          ),
          Container(
            height: 2 * height / 9,
            child: Center(
              child: Text(
                'Welcome',
                style: TextStyle(
                  color: lightNavy,
                  fontSize: height / 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            height: height / 9,
            width: width / 1.2,
            child: Column(
              children: <Widget>[
                FittedBox(
                  child: Text(
                    'Create an account and start planning ',
                    style: TextStyle(
                      color: navy,
                      fontSize: height / 40,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  fit: BoxFit.contain,
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    'with your friends',
                    style: TextStyle(
                      color: navy,
                      fontSize: height / 40,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              WavyFooter(
                height: height,
              ),
              CirclePink(
                height: height,
                width: width,
              ),
              CircleGreen(
                height: height,
                width: width,
              ),
              Transform.translate(
                offset: Offset(0, -height / 5),
                child: Center(
                  child: FlatButton(
                    onPressed: () {
                      widget.toggleView(AuthPageEnum.SignIn);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(width / 2),
                        side: BorderSide(color: Colors.white)),
                    textColor: Colors.white,
                    color: Color(0xFFFE8853),
                    padding: EdgeInsets.fromLTRB(
                        width / 4, height / 100, width / 4, height / 100),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text('Log In',
                          style: TextStyle(
                            fontSize: height / 30,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, -height / 3.6),
                child: Center(
                  child: FlatButton(
                    onPressed: () {
                      widget.toggleView(AuthPageEnum.Register);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(width / 2),
                        side: BorderSide(color: myOrange, width: width / 370)),
                    textColor: Color(0xFFFE8853),
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(
                        width / 4.4, height / 100, width / 4.4, height / 100),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text('Sign Up',
                          style: TextStyle(
                            fontSize: height / 30,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
