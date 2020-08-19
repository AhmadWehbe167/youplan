import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(25.0),
      ),
      child: RaisedButton(
        onPressed: () {},
        textColor: Colors.white,
        padding: const EdgeInsets.all(0.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xFF0D47A1),
                Color(0xFF1976D2),
                Color(0xFF42A5F5),
              ],
            ),
          ),
          padding: const EdgeInsets.all(10.0),
          child: const Text('Gradient Button', style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}

class MyImage extends StatelessWidget {
  final double myHeight;
  final String imageName;
  const MyImage({
    Key key,
    this.myHeight,
    this.imageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: myHeight,
      width: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/$imageName.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class MyAnimation extends StatelessWidget {
  final double myHeight;
  final String animationName;
  final String animationTitle;
  const MyAnimation({
    Key key,
    this.myHeight,
    this.animationName,
    this.animationTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: myHeight,
      width: 100,
      child: FlareActor(
        'animations/$animationTitle.flr',
        animation: animationName,
        fit: BoxFit.contain,
      ),
    );
  }
}
