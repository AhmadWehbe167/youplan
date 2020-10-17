import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
//
// class RoundedButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: new BorderRadius.circular(25.0),
//       ),
//       child: RaisedButton(
//         onPressed: () {},
//         textColor: Colors.white,
//         padding: const EdgeInsets.all(0.0),
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: <Color>[
//                 Color(0xFF0D47A1),
//                 Color(0xFF1976D2),
//                 Color(0xFF42A5F5),
//               ],
//             ),
//           ),
//           padding: const EdgeInsets.all(10.0),
//           child: const Text('Gradient Button', style: TextStyle(fontSize: 20)),
//         ),
//       ),
//     );
//   }
// }

//class MyImage extends StatelessWidget {
//  final double myHeight;
//  final double myWidth;
//  final String imageName;
//  const MyImage({
//    Key key,
//    this.myHeight,
//    this.imageName,
//    this.myWidth,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      height: myHeight,
//      width: myWidth,
//      decoration: BoxDecoration(
//        image: DecorationImage(
//          image: AssetImage('images/$imageName.png'),
//          fit: BoxFit.contain,
//        ),
//      ),
//    );
//  }
//}

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

class RoundedContainer extends StatelessWidget {
  final String title;
  final double borderRadius;
  final double containerHeight;
  final double fontSize;
  const RoundedContainer({
    @required this.title,
    @required this.borderRadius,
    @required this.containerHeight,
    @required this.fontSize,
    Key key,
  })  : assert(title != null),
        assert(borderRadius != null),
        assert(containerHeight != null),
        assert(fontSize != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: containerHeight,
        decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
            child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )),
      ),
    );
  }
}

class SubButton extends StatelessWidget {
  final String title;
  final double buttonWidth;
  const SubButton({
    Key key,
    this.buttonWidth,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        height: 30,
        width: buttonWidth,
        decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
            child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )),
      ),
    );
  }
}
