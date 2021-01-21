import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/Model/User_Data.dart';
import 'package:youplan/Profile/Helpers.dart';
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
    final user = Provider.of<Muser>(context);
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final user = Provider.of<Muser>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: headerBottomColor,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Lobster',
              fontSize: width * 0.09),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_rounded),
            onPressed: () {
              //TODO:Filter results PopUp
            },
          ),
        ],
      ),
      backgroundColor: background,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Friends')
              .doc(widget.userID)
              .snapshots(),
          builder: (context, snapshot1) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('User')
                    .doc(widget.userID)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    );
                  } else {
                    UserData userData = UserData(snapshot);
                    return !isConnected
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Opacity(
                                opacity: 0.75,
                                child: Center(
                                  child: Container(
                                    height: height * 0.3,
                                    width: width * 0.85,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('images/NoNet.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: 0.75,
                                child: Text(
                                  'Check your internet Connection',
                                  style: TextStyle(
                                    color: Color(0xFF9CC3CC),
                                    fontSize: width * 0.062,
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: 0.75,
                                child: Text(
                                  'and try again',
                                  style: TextStyle(
                                    color: Color(0xFF9CC3CC),
                                    fontSize: width * 0.062,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              Container(
                                height: height * 0.42,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(70),
                                      bottomRight: Radius.circular(70),
                                    ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        headerBottomColor,
                                        Color(0xFF63A7BE),
                                      ],
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: height * 0.08),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: height * 0.6,
                                    width: width * 0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: height * 0.015,
                                        ),
                                        CircleAvatar(
                                          radius: height * 0.12,
                                          backgroundImage:
                                              userData.profileImage == null
                                                  ? AssetImage(
                                                      "images/userIcon.png",
                                                    )
                                                  : NetworkImage(
                                                      userData.profileImage),
                                        ),
                                        SizedBox(
                                          height: height * 0.003,
                                        ),
                                        Text(
                                          userData.fullName,
                                          style: TextStyle(
                                            fontSize: width * 0.07,
                                            fontWeight: FontWeight.w400,
                                            color: background,
                                          ),
                                        ),
                                        Text(
                                          "@" + userData.userName,
                                          style: TextStyle(
                                            fontSize: width * 0.05,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff517994),
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: width * 0.05,
                                            right: width * 0.05,
                                          ),
                                          child: Text(
                                            //TODO::BIO max is 112
                                            userData.bio,
                                            style: TextStyle(
                                              fontSize: width * 0.049,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff517994),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: width * 0.05,
                                            ),
                                            CountDisplay(
                                              title: "Friends",
                                              height: height,
                                              width: width,
                                              count: snapshot1
                                                  .data["friends"].length,
                                              color: background,
                                            ),
                                            Expanded(child: Container()),
                                            CountDisplay(
                                              height: height,
                                              width: width,
                                              count: userData.plansCount,
                                              title: "Plans",
                                              color: Color(0xff1495B3),
                                            ),
                                            SizedBox(
                                              width: width * 0.05,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.03,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                  }
                });
          }),
    );
  }
}
