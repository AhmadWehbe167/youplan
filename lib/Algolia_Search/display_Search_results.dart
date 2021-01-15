import 'package:flutter/material.dart';
import 'package:youplan/Model/Users_Data.dart';

class DisplaySearchResult extends StatelessWidget {
  final String fullName;
  final String userName;
  final String receiverId;
  final Function fun;
  DisplaySearchResult(
      {Key key, this.userName, this.fullName, this.receiverId, this.fun})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fun,
      child: Column(children: <Widget>[
        Text(
          fullName ?? "",
          style: TextStyle(color: Colors.white),
        ),
        Text(
          userName ?? "",
          style: TextStyle(color: Colors.white),
        ),
        Divider(
          color: Colors.black,
        ),
        SizedBox(height: 20)
      ]),
    );
  }
}

class DisplayUserData extends StatelessWidget {
  final UserData userData;
  const DisplayUserData({
    this.userData,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      userData.fullName,
      style: TextStyle(color: Colors.white),
    ));
  }
}
