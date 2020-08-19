import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Home_Package/Challenges_Home/Create_Challenge_Page.dart';
import 'package:youplan/Home_Package/Refactored_Widgets/plan_card.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/services/Challenge_Requests_database.dart';

class ChallengesHomePage extends StatefulWidget {
  @override
  _ChallengesHomePageState createState() => _ChallengesHomePageState();
}

class _ChallengesHomePageState extends State<ChallengesHomePage> {
  final newGlobalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      key: newGlobalKey,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateChallengePage(),
                  ),
                );
              },
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text(
                  'Add Challenge',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                  ),
                )),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('Challenges')
                    .document(user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('An Error Occurred'),
                    );
                  } else {
                    var userDoc = snapshot.data['challenges'];
                    return ListView.builder(
                        itemCount: userDoc.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  //TODO:: Navigate to Challenge Page
                                },
                                child: ChallengeCard(
                                  imageTitle: 'Nature',
                                  title: userDoc[index]['title'],
                                  description:
                                      userDoc[index]['description'] ?? '',
                                  notes: userDoc[index]['notes'] ?? '',
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
                                            child: CircularProgressIndicator()),
                                      );
                                      try {
                                        await CRDatabaseServices(uid: user.uid)
                                            .checkCreatorComplete(
                                              userDoc[index]['isCreator'],
                                              userDoc[index]['creator uid'],
                                              userDoc[index]
                                                  ['creator userName'],
                                              userDoc[index]
                                                  ['creator fullName'],
                                              userDoc[index]['title'],
                                              userDoc[index]['description'],
                                              userDoc[index]['notes'],
                                            )
                                            .timeout(Duration(seconds: 5))
                                            .then((value) {
                                          final requestSentSnackBar = SnackBar(
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
                                        final requestSentSnackBar = SnackBar(
                                            content: Text(
                                                'Check Your internet Connection and try again!'));
                                        newGlobalKey.currentState
                                            .showSnackBar(requestSentSnackBar);
                                      }
                                    },
                                    child: Text(
                                      'Complete',
                                      style: TextStyle(color: Colors.white),
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
                                        await CRDatabaseServices(uid: user.uid)
                                            .checkCreatorCancelChallenge(
                                                userDoc[index]['isCreator'],
                                                userDoc[index]['creator uid'],
                                                userDoc[index]
                                                    ['creator userName'],
                                                userDoc[index]
                                                    ['creator fullName'],
                                                userDoc[index]['title'],
                                                userDoc[index]['description'],
                                                userDoc[index]['notes'])
                                            .timeout(Duration(seconds: 10))
                                            .then((value) {
                                          final requestSentSnackBar = SnackBar(
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
                                        final requestSentSnackBar = SnackBar(
                                            content: Text(
                                                'Check Your internet Connection and try again!'));
                                        newGlobalKey.currentState
                                            .showSnackBar(requestSentSnackBar);
                                      }
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Colors.red,
                                  ),
                                ],
                              )
                            ],
                          );
                        });
                  }
                }),
          ),
        ],
      ),
    );
  }
}
