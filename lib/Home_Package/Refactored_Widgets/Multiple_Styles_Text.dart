import 'package:flutter/material.dart';

class MulStylesText extends StatelessWidget {
  final String definition;
  final String value;
  const MulStylesText({
    Key key,
    @required this.definition,
    @required this.value,
  })  : assert(definition != null),
        assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 14, color: Colors.black),
        children: <TextSpan>[
          TextSpan(
              text: '$definition: ',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
