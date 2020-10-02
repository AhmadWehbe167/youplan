import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Home_Package/Refactored_Widgets/ChallengeCard.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/Model/Users_Data.dart';
import 'package:youplan/services/Challenge_Requests_database.dart';
import 'package:youplan/services/ConnectionCheck.dart';

class ChallengesHomePage extends StatefulWidget {
  final UserData friend;
  final String time;
  final bool isAll;

  ChallengesHomePage({
    this.friend,
    this.time,
    this.isAll,
  });

  @override
  _ChallengesHomePageState createState() => _ChallengesHomePageState();
}

class _ChallengesHomePageState extends State<ChallengesHomePage> {
  final newGlobalKey = GlobalKey<ScaffoldState>();
  bool isConnected = true;

  getConnection() async {
    isConnected = await checkConnection();
  }

  checkUserInFriendsList(
      List friendsList, UserData friend, bool isAll, String creatorID) {
    if (isAll) {
      return true;
    } else {
      return friendsList.contains(friend) || friend.uid == creatorID;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getConnection();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: newGlobalKey,
      body: !isConnected
          ? Center(
              child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                'No Internet Connection',
                style: TextStyle(
                  fontFamily: 'Lobster',
                  fontSize: width / 12,
                  color: lightNavy,
                ),
              ),
            ))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('Challenges')
                  .document(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        'Loading ...',
                        style: TextStyle(
                          fontFamily: 'Lobster',
                          fontSize: width / 12,
                          fontWeight: FontWeight.bold,
                          color: lightNavy,
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.data['challenges'].length == 0) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'You Have No',
                          style: TextStyle(
                            fontFamily: 'ConcertOne',
                            fontSize: width / 8,
                            color: lightNavy,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Challenges',
                          style: TextStyle(
                            fontFamily: 'ArchitectsDaughter',
                            fontSize: width / 8,
                            fontWeight: FontWeight.bold,
                            color: lightNavy,
                          ),
                        ),
                      ),
                    ],
                  ));
                } else {
                  var userDoc = snapshot.data['challenges'];
                  return ListView.builder(
                      itemCount: userDoc.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return StreamBuilder(
                            stream: Firestore.instance
                                .collection('challengeNames')
                                .document(userDoc[index]['creator uid'])
                                .snapshots(),
                            builder: (context, snapshot2) {
                              if (!snapshot2.hasData) {
                                return Center(
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      'Loading ...',
                                      style: TextStyle(
                                        fontFamily: 'Lobster',
                                        fontSize: width / 12,
                                        fontWeight: FontWeight.bold,
                                        color: lightNavy,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                var challengeNamesDoc = snapshot2.data;
                                var title = userDoc[index]['title'];
                                return checkUserInFriendsList(
                                        challengeNamesDoc[
                                            '$title Accepted Friends'],
                                        widget.friend,
                                        widget.isAll,
                                        userDoc[index]['creator uid'])
                                    ? Column(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              //TODO:: Navigate to Challenge Page
                                            },
                                            child: ChallengeCard(
                                              imageTitle: 'goal',
                                              title: userDoc[index]['title'],
                                              description: userDoc[index]
                                                      ['description'] ??
                                                  '',
                                              notes:
                                                  userDoc[index]['notes'] ?? '',
                                              elevate: true,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              RaisedButton(
                                                elevation: 5,
                                                onPressed: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                  );
                                                  try {
                                                    await CRDatabaseServices(
                                                            uid: user.uid)
                                                        .checkCreatorComplete(
                                                          userDoc[index]
                                                              ['isCreator'],
                                                          userDoc[index]
                                                              ['creator uid'],
                                                          userDoc[index][
                                                              'creator userName'],
                                                          userDoc[index][
                                                              'creator fullName'],
                                                          userDoc[index]
                                                              ['title'],
                                                          userDoc[index]
                                                              ['description'],
                                                          userDoc[index]
                                                              ['notes'],
                                                        )
                                                        .timeout(Duration(
                                                            seconds: 5))
                                                        .then((value) {
                                                      final requestSentSnackBar =
                                                          SnackBar(
                                                              content: Text(
                                                                  'Challenge completed Successfully!'));
                                                      newGlobalKey.currentState
                                                          .showSnackBar(
                                                              requestSentSnackBar);
                                                    }).whenComplete(() {
                                                      Navigator.pop(context);
                                                    });
                                                  } catch (e) {
                                                    print(e.toString());
                                                    final requestSentSnackBar =
                                                        SnackBar(
                                                            content: Text(
                                                                'Check Your internet Connection and try again!'));
                                                    newGlobalKey.currentState
                                                        .showSnackBar(
                                                            requestSentSnackBar);
                                                  }
                                                },
                                                child: Text(
                                                  'Complete',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: Colors.green,
                                              ),
                                              RaisedButton(
                                                elevation: 5,
                                                onPressed: () async {
                                                  try {
                                                    showDialog(
                                                        context: ctxt,
                                                        builder: (ctxt) => Center(
                                                            child:
                                                                CircularProgressIndicator()));
                                                    await CRDatabaseServices(
                                                            uid: user.uid)
                                                        .checkCreatorCancelChallenge(
                                                            userDoc[index]
                                                                ['isCreator'],
                                                            userDoc[index]
                                                                ['creator uid'],
                                                            userDoc[index][
                                                                'creator userName'],
                                                            userDoc[index][
                                                                'creator fullName'],
                                                            userDoc[index]
                                                                ['title'],
                                                            userDoc[index]
                                                                ['description'],
                                                            userDoc[index]
                                                                ['notes'])
                                                        .timeout(Duration(
                                                            seconds: 10))
                                                        .then((value) {
                                                      final requestSentSnackBar =
                                                          SnackBar(
                                                              content: Text(
                                                                  'Challenge is Canceled!'));
                                                      newGlobalKey.currentState
                                                          .showSnackBar(
                                                              requestSentSnackBar);
                                                    }).whenComplete(() {
                                                      Navigator.pop(ctxt);
                                                    });
                                                  } catch (e) {
                                                    print(e.toString());
                                                    final requestSentSnackBar =
                                                        SnackBar(
                                                            content: Text(
                                                                'Check Your internet Connection and try again!'));
                                                    newGlobalKey.currentState
                                                        .showSnackBar(
                                                            requestSentSnackBar);
                                                  }
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: Colors.red,
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    : Container();
                              }
                            });
                      });
                }
              }),
    );
  }
}
