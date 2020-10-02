import 'package:flutter/material.dart';

class MulStylesText extends StatelessWidget {
  final String definition;
  final String value;
  final double fontSize;
  const MulStylesText({
    Key key,
    @required this.definition,
    @required this.value,
    @required this.fontSize,
  })  : assert(definition != null),
        assert(value != null),
        assert(fontSize != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold),
        children: <TextSpan>[
          TextSpan(
              text: '$definition: ',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.tealAccent)),
          TextSpan(text: value),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
