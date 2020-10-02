import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Home_Package/Refactored_Widgets/ChallengeCard.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/services/Challenge_Requests_database.dart';

final globalKey = GlobalKey<ScaffoldState>();

class ChallengeRequestsPage extends StatefulWidget {
  @override
  _ChallengeRequestsPageState createState() => _ChallengeRequestsPageState();
}

class _ChallengeRequestsPageState extends State<ChallengeRequestsPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      key: globalKey,
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('Requests')
              .document(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('no data'),
              );
            } else {
              var userDoc = snapshot.data['challenges'];
              if (userDoc == null) {
                return Container();
              } else {
                return ListView.builder(
                    itemCount: userDoc.length,
                    itemBuilder: (BuildContext context, int index) {
                      var uid = userDoc[index]['creator uid'];
                      var userName = userDoc[index]['creator userName'];
                      var fullName = userDoc[index]['creator fullName'];
                      var title = userDoc[index]['title'];
                      var description = userDoc[index]['description'];
                      var notes = userDoc[index]['notes'];
                      bool isCreator = userDoc[index]['isCreator'];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 7,
                          child: GestureDetector(
                            onTap:
//                            fun,
                                () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                  builder: (context) => ViewPlan(
//                                    index: index,
//                                    uid: uid,
//                                    userName: userName,
//                                    fullName: fullName,
//                                    title: title,
//                                    type: type,
//                                    selectedDate: DateFormat('yMd')
//                                        .format(selectedDate.toDate()),
//                                    place: place ?? '',
//                                    description: description ?? '',
//                                    notes: notes ?? '',
//                                    isCreator: isCreator,
//                                  ),
//                                ),
//                              );
                            },
                            child: Column(
                              children: <Widget>[
                                ChallengeCard(
                                  imageTitle: 'restaurant',
                                  title: title,
                                  description: description,
                                  notes: notes,
                                  elevate: true,
                                ),
                                isCreator == false
                                    ? Row(
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
                                                          CircularProgressIndicator()));
                                              try {
                                                await CRDatabaseServices(
                                                        uid: user.uid)
                                                    .acceptChallengeRequest(
                                                      uid,
                                                      userName,
                                                      fullName,
                                                      title,
                                                      description,
                                                      notes,
                                                      isCreator,
                                                    )
                                                    .timeout(
                                                        Duration(seconds: 5))
                                                    .then((value) {
                                                  final requestSentSnackBar =
                                                      SnackBar(
                                                          content: Text(
                                                              'Challenge Accepted Successfully!'));
                                                  globalKey.currentState
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
                                                globalKey.currentState
                                                    .showSnackBar(
                                                        requestSentSnackBar);
                                              }
                                            },
                                            child: Text(
                                              'Accept',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: Colors.green,
                                          ),
                                          RaisedButton(
                                            elevation: 5,
                                            onPressed: () async {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => Center(
                                                      child:
                                                          CircularProgressIndicator()));
                                              try {
                                                await CRDatabaseServices(
                                                        uid: user.uid)
                                                    .rejectChallengeRequest(
                                                      uid,
                                                      userName,
                                                      fullName,
                                                      title,
                                                      description,
                                                      notes,
                                                      isCreator,
                                                    )
                                                    .timeout(
                                                        Duration(seconds: 5))
                                                    .then((value) {
                                                  final requestSentSnackBar =
                                                      SnackBar(
                                                          content: Text(
                                                              'Challenge Rejected!'));
                                                  globalKey.currentState
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
                                                globalKey.currentState
                                                    .showSnackBar(
                                                        requestSentSnackBar);
                                              }
                                            },
                                            child: Text(
                                              'Reject',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: Colors.red,
                                          ),
                                        ],
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 6,
                                              child: Text(
                                                'Friends accepted your request',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: SizedBox(),
                                            ),
                                            Expanded(
                                              child: Text(
                                                '0',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
            }
          }),
    );
  }
}
