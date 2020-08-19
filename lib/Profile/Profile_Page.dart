import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Explore/Explore_Page.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/Profile/Friends_List.dart';
import 'package:youplan/services/ConnectionCheck.dart';
import 'package:youplan/services/Friend_Requests_database.dart';

class ProfilePage extends StatefulWidget {
  final String userID;
  const ProfilePage({this.userID});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

enum FriendState {
  isFriend,
  sentRequestByMe,
  sentMeRequest,
  nonFriend,
}

class _ProfilePageState extends State<ProfilePage> {
  TextStyle myStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  final globalKey = GlobalKey<ScaffoldState>();
  FriendState friendState;
  bool isMyFriend;
  bool hasSentMeRequest;
  bool iSentHimRequest;
  bool isConnected = true;

  getConnection() async {
    isConnected = await checkConnection();
  }

  getData() async {
    final user = Provider.of<User>(context);
    try {
      iSentHimRequest = await FRDatabaseService(uid: user.uid)
          .userSentRequestByMe(widget.userID);
    } catch (e) {
      print(e.toString());
    }
    if (iSentHimRequest) {
      setState(() {
        friendState = FriendState.sentRequestByMe;
      });
    } else {
      try {
        hasSentMeRequest = await FRDatabaseService(uid: user.uid)
            .userSentMeRequest(widget.userID);
      } catch (e) {
        print(e.toString());
      }
      if (hasSentMeRequest) {
        setState(() {
          friendState = FriendState.sentMeRequest;
        });
      } else {
        try {
          isMyFriend = await FRDatabaseService(uid: user.uid)
              .userIsFriend(widget.userID);
        } catch (e) {
          print(e.toString());
        }
        if (isMyFriend) {
          setState(() {
            friendState = FriendState.isFriend;
          });
        } else {
          setState(() {
            friendState = FriendState.nonFriend;
          });
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getData();
    getConnection();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return !isConnected
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(
                'Page Not Found. Check your internet Connection and try again',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : StreamBuilder(
            stream: Firestore.instance
                .collection('User')
                .document(widget.userID)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Text(
                      'Loading ...',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } else {
                var userDoc = snapshot.data;
                return Scaffold(
                  key: globalKey,
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    title: Text(
                      'Profile Page',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Lobster',
                          fontSize: 30),
                    ),
                  ),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Image.asset('images/user.png'),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  user.uid == widget.userID
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FriendsList(
                                              userId: widget.userID,
                                            ),
                                          ),
                                        )
                                      : showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text(
                                                  'Friends list is Private',
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('OK'),
                                                  )
                                                ],
                                              ));
                                },
                                child: RoundedContainer(
                                  title: ' Friends ',
                                  borderRadius: 10,
                                  containerHeight: 100,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            Expanded(
                              child: RoundedContainer(
                                title: ' XP Points ',
                                borderRadius: 10,
                                containerHeight: 100,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      user.uid != widget.userID
                          ? friendState == FriendState.sentMeRequest
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        'Accept',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.grey,
                                      onPressed: () async {
                                        try {
                                          showDialog(
                                              context: context,
                                              builder: (context) => Center(
                                                  child:
                                                      CircularProgressIndicator()));
                                          await FRDatabaseService(uid: user.uid)
                                              .acceptFriendRequest(
                                                  widget.userID)
                                              .timeout(Duration(seconds: 5))
                                              .then((value) {
                                            setState(() {
                                              final requestSentSnackBar = SnackBar(
                                                  content: Text(
                                                      'You are friends now!'));
                                              globalKey.currentState
                                                  .showSnackBar(
                                                      requestSentSnackBar);
                                              friendState =
                                                  FriendState.isFriend;
                                            });
                                          }).whenComplete(() {
                                            Navigator.pop(context);
                                          });
                                        } catch (e) {
                                          print(e.toString());
                                          final requestSentSnackBar = SnackBar(
                                              content: Text(
                                                  'Check Your internet Connection and try again!'));
                                          globalKey.currentState.showSnackBar(
                                              requestSentSnackBar);
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    FlatButton(
                                      child: Text(
                                        'Reject',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.grey,
                                      onPressed: () async {
                                        try {
                                          showDialog(
                                              context: context,
                                              builder: (context) => Center(
                                                  child:
                                                      CircularProgressIndicator()));
                                          await FRDatabaseService(uid: user.uid)
                                              .rejectFriendRequest(
                                                  widget.userID)
                                              .timeout(Duration(seconds: 5))
                                              .then((value) {
                                            setState(() {
                                              friendState =
                                                  FriendState.nonFriend;
                                            });
                                          }).whenComplete(() {
                                            Navigator.pop(context);
                                          });
                                        } catch (e) {
                                          print(e.toString());
                                          final requestSentSnackBar = SnackBar(
                                              content: Text(
                                                  'Check Your Internet Connection and try again!'));
                                          globalKey.currentState.showSnackBar(
                                              requestSentSnackBar);
                                        }
                                      },
                                    ),
                                  ],
                                )
                              : FlatButton(
                                  onPressed: () async {
                                    if (friendState == FriendState.nonFriend) {
                                      try {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Center(
                                                child:
                                                    CircularProgressIndicator()));
                                        await FRDatabaseService(uid: user.uid)
                                            .sendFriendRequest(widget.userID)
                                            .timeout(Duration(seconds: 5))
                                            .then((value) {
                                          final requestSentSnackBar = SnackBar(
                                              content: Text(
                                                  'Request Sent Successfully!'));
                                          globalKey.currentState.showSnackBar(
                                              requestSentSnackBar);
                                          setState(() {
                                            friendState =
                                                FriendState.sentRequestByMe;
                                          });
                                        }).whenComplete(() {
                                          Navigator.pop(context);
                                        });
                                      } catch (e) {
                                        final requestSentSnackBar = SnackBar(
                                            content: Text(
                                          'Check Your Internet Connection and try again!',
                                        ));
                                        globalKey.currentState
                                            .showSnackBar(requestSentSnackBar);
                                      }
                                    } else if (friendState ==
                                        FriendState.isFriend) {
                                      try {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Center(
                                                child:
                                                    CircularProgressIndicator()));
                                        await FRDatabaseService(uid: user.uid)
                                            .unFriendUser(widget.userID)
                                            .timeout(Duration(seconds: 5))
                                            .then((value) {
                                          setState(() {
                                            final requestSentSnackBar = SnackBar(
                                                content: Text(
                                                    'You are not friends anymore!'));
                                            globalKey.currentState.showSnackBar(
                                                requestSentSnackBar);
                                            friendState = FriendState.nonFriend;
                                          });
                                        }).whenComplete(() {
                                          Navigator.pop(context);
                                        });
                                      } catch (e) {
                                        final requestSentSnackBar = SnackBar(
                                            content: Text(
                                                'Check Your internet Connection and try again!'));
                                        globalKey.currentState
                                            .showSnackBar(requestSentSnackBar);
                                      }
                                    } else if (friendState ==
                                        FriendState.sentRequestByMe) {
                                      try {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Center(
                                                child:
                                                    CircularProgressIndicator()));
                                        await FRDatabaseService(uid: user.uid)
                                            .cancelFriendRequest(widget.userID)
                                            .timeout(Duration(seconds: 5))
                                            .then((value) {
                                          final requestSentSnackBar = SnackBar(
                                              content: Text(
                                                  'Request Canceled Successfully!'));
                                          globalKey.currentState.showSnackBar(
                                              requestSentSnackBar);
                                          setState(() {
                                            friendState = FriendState.nonFriend;
                                          });
                                        }).whenComplete(() {
                                          Navigator.pop(context);
                                        });
                                      } catch (e) {
                                        final requestSentSnackBar = SnackBar(
                                            content: Text(
                                                'Check Your Internet Connection and try again'));
                                        globalKey.currentState
                                            .showSnackBar(requestSentSnackBar);
                                      }
                                    }
                                  },
                                  child: Text(
                                    friendState == FriendState.isFriend
                                        ? 'UnFriend'
                                        : friendState ==
                                                FriendState.sentRequestByMe
                                            ? 'Cancel request'
                                            : friendState ==
                                                    FriendState.sentMeRequest
                                                ? 'Accept'
                                                : friendState ==
                                                        FriendState.nonFriend
                                                    ? 'Add Friend'
                                                    : '',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.grey,
                                )
                          : Container(),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Text(
                          userDoc['fullName'],
                          style: myStyle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          userDoc['userName'],
                          style: myStyle,
                        ),
                      ),
                    ],
                  ),
                );
              }
            });
  }
}
