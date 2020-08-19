import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Home_Package/PLans_Home/Attendees_Check_Box.dart';
import 'package:youplan/Home_Package/PLans_Home/Create_Plan_Page.dart';
import 'package:youplan/Home_Package/PLans_Home/Planfunctions.dart';
import 'package:youplan/Home_Package/Refactored_Widgets/plan_card.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/Requests/PLan_Requests/ViewPlan.dart';
import 'package:youplan/services/Plan_Requests_database.dart';

class PlansHomePage extends StatefulWidget {
  @override
  _PlansHomePageState createState() => _PlansHomePageState();
}

class _PlansHomePageState extends State<PlansHomePage> {
  final globalKey = GlobalKey<ScaffoldState>();
  var loading = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      key: globalKey,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePlanPage(),
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
                  'Add Plan',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                  ),
                )),
              ),
            ),
          ),
          loading
              ? Container()
              : Expanded(
                  child: StreamBuilder(
                      stream: Firestore.instance
                          .collection('Plans')
                          .document(user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text('An Error Occurred'),
                          );
                        } else {
                          var userDoc = snapshot.data['plans'];
                          return ListView.builder(
                              itemCount: snapshot.data['plans'].length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            ctxt,
                                            MaterialPageRoute(
                                                builder: (context) => ViewPlan(
                                                      title: userDoc[index]
                                                          ['title'],
                                                      type: userDoc[index]
                                                          ['type'],
                                                      uid: userDoc[index]
                                                          ['creator uid'],
                                                      place: userDoc[index]
                                                          ['place'],
                                                      selectedDate: DateFormat(
                                                              'yMd')
                                                          .format(userDoc[index]
                                                                  ['date']
                                                              .toDate()),
                                                      fullName: userDoc[index]
                                                          ['creator fullName'],
                                                      userName: userDoc[index]
                                                          ['creator userName'],
                                                      isCreator: userDoc[index]
                                                          ['isCreator'],
                                                      description: userDoc[
                                                          'description'],
                                                      index: index,
                                                      notes: userDoc[index]
                                                          ['notes'],
                                                    )));
                                      },
                                      child: PlanCard(
                                        imageTitle: 'Movies',
                                        title: userDoc[index]['title'],
                                        type: userDoc[index]['type'],
                                        date: userDoc[index]['date'].toDate(),
                                        locationDescription:
                                            userDoc[index]['place'] ?? '',
                                        isPLan: true,
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
                                              var result;
                                              if (userDoc[index]['isCreator'] ==
                                                  true) {
                                                result = await Navigator.push(
                                                  ctxt,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AttendeesCheckBox(
                                                      senderID: user.uid,
                                                      title: userDoc[index]
                                                          ['title'],
                                                    ),
                                                  ),
                                                );
                                                if (result != null) {
                                                  await completePlan(
                                                    ctxt,
                                                    userDoc[index]['isCreator'],
                                                    user.uid,
                                                    userDoc[index]['title'],
                                                    userDoc[index]
                                                        ['creator uid'],
                                                    userDoc[index]
                                                        ['creator userName'],
                                                    userDoc[index]
                                                        ['creator fullName'],
                                                    userDoc[index]['date'],
                                                    userDoc[index]['place'],
                                                    userDoc[index]['type'],
                                                    userDoc[index]
                                                        ['description'],
                                                    userDoc[index]['notes'],
                                                    result,
                                                  )
                                                      .timeout(
                                                          Duration(seconds: 5))
                                                      .then((value) {
                                                    final requestSentSnackBar =
                                                        SnackBar(
                                                            content: Text(
                                                                'Plan completed Successfully!'));
                                                    globalKey.currentState
                                                        .showSnackBar(
                                                            requestSentSnackBar);
                                                  }).whenComplete(() {
                                                    Navigator.pop(context);
                                                  });
                                                } else {
                                                  Navigator.pop(context);
                                                }
                                              } else {
                                                await completePlan(
                                                  ctxt,
                                                  userDoc[index]['isCreator'],
                                                  user.uid,
                                                  userDoc[index]['title'],
                                                  userDoc[index]['creator uid'],
                                                  userDoc[index]
                                                      ['creator userName'],
                                                  userDoc[index]
                                                      ['creator fullName'],
                                                  userDoc[index]['date'],
                                                  userDoc[index]['place'],
                                                  userDoc[index]['type'],
                                                  userDoc[index]['description'],
                                                  userDoc[index]['notes'],
                                                  result,
                                                )
                                                    .timeout(
                                                        Duration(seconds: 5))
                                                    .then((value) {
                                                  final requestSentSnackBar =
                                                      SnackBar(
                                                          content: Text(
                                                              'Plan completed Successfully!'));
                                                  globalKey.currentState
                                                      .showSnackBar(
                                                          requestSentSnackBar);
                                                }).whenComplete(() {
                                                  Navigator.pop(context);
                                                });
                                              }
                                            } catch (e) {
                                              print(e.toString());
                                              final requestSentSnackBar = SnackBar(
                                                  content: Text(
                                                      'Check Your internet Connection and try again!'));
                                              globalKey.currentState
                                                  .showSnackBar(
                                                      requestSentSnackBar);
                                            }
                                          },
                                          child: Text(
                                            'Complete',
                                            style:
                                                TextStyle(color: Colors.white),
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
                                              await PRDatabaseServices(
                                                      uid: user.uid)
                                                  .checkCreatorCancel(
                                                      userDoc[index]
                                                          ['isCreator'],
                                                      userDoc[index]
                                                          ['creator uid'],
                                                      userDoc[index]
                                                          ['creator userName'],
                                                      userDoc[index]
                                                          ['creator fullName'],
                                                      userDoc[index]['title'],
                                                      userDoc[index]['date'],
                                                      userDoc[index]['place'],
                                                      userDoc[index]['type'],
                                                      userDoc[index]
                                                          ['description'],
                                                      userDoc[index]['notes'])
                                                  .timeout(
                                                      Duration(seconds: 10))
                                                  .then((value) {
                                                final requestSentSnackBar =
                                                    SnackBar(
                                                        content: Text(
                                                            'Plan is Canceled!'));
                                                globalKey.currentState
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
                                              globalKey.currentState
                                                  .showSnackBar(
                                                      requestSentSnackBar);
                                            }
                                          },
                                          child: Text(
                                            'Cancel',
                                            style:
                                                TextStyle(color: Colors.white),
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
