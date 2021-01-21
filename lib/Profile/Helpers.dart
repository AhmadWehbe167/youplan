import 'package:flutter/material.dart';

class CountDisplay extends StatelessWidget {
  const CountDisplay({
    Key key,
    @required this.height,
    @required this.width,
    @required this.count,
    @required this.title,
    @required this.color,
  }) : super(key: key);

  final double height;
  final double width;
  final int count;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.06,
      width: width * 0.37,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(
            left: width * 0.02,
            right: width * 0.02,
          ),
          child: Row(
            children: [
              Text(
                "$title ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: height * 0.025,
                ),
              ),
              Expanded(child: Container()),
              Text(
                "$count",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: height * 0.025,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
