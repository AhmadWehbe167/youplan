import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/Profile/Profile_Page.dart';
import 'package:youplan/services/Friend_Requests_database.dart';

class UserFriendRequest extends StatefulWidget {
  final String userName;
  final String fullName;
  final String userId;
  final GlobalKey<ScaffoldState> globalKey;
  const UserFriendRequest({
    this.userName,
    this.fullName,
    this.userId,
    this.globalKey,
    Key key,
  }) : super(key: key);

  @override
  _UserFriendRequestState createState() => _UserFriendRequestState();
}

class _UserFriendRequestState extends State<UserFriendRequest> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Muser>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      userID: widget.userId,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('images/user.png'),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(
                      userID: widget.userId,
                    ),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.fullName}',
                    style: TextStyle(fontSize: 23),
                  ),
                  Text(
                    '${widget.userName}',
                    style: TextStyle(fontSize: 23),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () async {
                        try {
                          await FRDatabaseService(uid: user.uid)
                              .acceptFriendRequest(widget.userId);
                        } catch (e) {
                          final requestSentSnackBar = SnackBar(
                              content: Text(
                                  'Check your internet connection and try again'));
                          widget.globalKey.currentState
                              .showSnackBar(requestSentSnackBar);
                          print(e.toString());
                        }
                      },
                      child: Icon(
                        Icons.check,
                        size: 50,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        try {
                          FRDatabaseService(uid: user.uid)
                              .rejectFriendRequest(widget.userId);
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      child: Icon(
                        Icons.cancel,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UserFriends extends StatefulWidget {
  final String userName;
  final String fullName;
  final String userId;
  const UserFriends({
    this.userName,
    this.fullName,
    this.userId,
    Key key,
  }) : super(key: key);

  @override
  _UserFriendsState createState() => _UserFriendsState();
}

class _UserFriendsState extends State<UserFriends> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Muser>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              userID: widget.userId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('images/user.png'),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.fullName}',
                      style: TextStyle(fontSize: 23),
                    ),
                    Text(
                      '${widget.userName}',
                      style: TextStyle(fontSize: 23),
                    ),
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {
                  FRDatabaseService(uid: user.uid).unFriendUser(widget.userId);
                },
                child: Text(
                  'UnFriend',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
