import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Home_Package/Refactored_Widgets/plan_card.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/Model/User_Data.dart';
import 'package:youplan/services/ConnectionCheck.dart';
import 'package:youplan/services/Plan_Requests_database.dart';

import 'Attendees_Check_Box.dart';
import 'Planfunctions.dart';

class PlansHomePage extends StatefulWidget {
  final UserData friend;
  final String time;
  final bool isAll;
  PlansHomePage({
    this.friend,
    this.time,
    this.isAll,
  });
  @override
  _PlansHomePageState createState() => _PlansHomePageState();
}

class _PlansHomePageState extends State<PlansHomePage> {
  final globalKey = GlobalKey<ScaffoldState>();
  var loading = false;
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

  bool checkDate(
    String dateVal,
    DateTime planDate,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    if (planDate == null) {
      return true;
    } else {
      if (dateVal == 'Today') {
        return (planDate.year == today.year &&
            planDate.month == today.month &&
            planDate.day == today.day);
      } else if (dateVal == 'Tomorrow') {
        return (planDate.year == tomorrow.year &&
            planDate.month == tomorrow.month &&
            planDate.day == tomorrow.day);
      } else {
        return true;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getConnection();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final user = Provider.of<Muser>(context);
    return Scaffold(
      backgroundColor: background,
      key: globalKey,
      body: loading
          ? Container()
          : !isConnected
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
                  stream: FirebaseFirestore.instance
                      .collection('Plans')
                      .doc(user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || !hasField(snapshot, 'plans')) {
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
                    } else if (hasField(snapshot, 'plans') &&
                        snapshot.data['plans'].length == 0) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: height * 0.05,
                            ),
                            Opacity(
                              opacity: 0.75,
                              child: Container(
                                height: height * 0.4,
                                width: width * 0.9,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('images/NoPlan.png'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: 0.75,
                              child: Text(
                                'No Plans Yet Create One',
                                style: TextStyle(
                                  color: Color(0xFF9CC3CC),
                                  fontSize: width * 0.075,
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: 0.75,
                              child: Text(
                                'and Get Started',
                                style: TextStyle(
                                  color: Color(0xFF9CC3CC),
                                  fontSize: width * 0.075,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.12,
                            ),
                          ],
                        ),
                      );
                    } else {
                      var userDoc = snapshot.data['plans'];
                      return ListView.builder(
                          itemCount: snapshot.data['plans'].length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('planNames')
                                    .doc(userDoc[index]['creator uid'])
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
                                    var title = userDoc[index]['title'];
                                    var planNamesDoc = snapshot2.data;
                                    return checkUserInFriendsList(
                                            planNamesDoc[
                                                '$title Accepted Friends'],
                                            widget.friend,
                                            widget.isAll,
                                            userDoc[index]['creator uid'])
                                        ? checkDate(
                                            widget.time,
                                            userDoc[index]['date'].toDate(),
                                          )
                                            ? PlanCard(
                                                userDoc: userDoc,
                                                user: user,
                                                globalKey: globalKey,
                                                ctxt: ctxt,
                                                index: index,
                                                creatorFullName: userDoc[index]
                                                    ['creator fullName'],
                                                date: userDoc[index]['date']
                                                    .toDate(),
                                                location: userDoc[index]
                                                    ['place'],
                                                title: userDoc[index]['title'],
                                                leftButtonText: 'Complete',
                                                rightButtonText: 'Cancel',
                                                leftButtonFun: () async {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                  );
                                                  try {
                                                    var result;
                                                    if (userDoc[index]
                                                            ['isCreator'] ==
                                                        true) {
                                                      result =
                                                          await Navigator.push(
                                                        ctxt,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              AttendeesCheckBox(
                                                            senderID: user.uid,
                                                            title:
                                                                userDoc[index]
                                                                    ['title'],
                                                          ),
                                                        ),
                                                      );
                                                      if (result != null) {
                                                        await completePlan(
                                                          ctxt,
                                                          userDoc[index]
                                                              ['isCreator'],
                                                          user.uid,
                                                          userDoc[index]
                                                              ['title'],
                                                          userDoc[index]
                                                              ['creator uid'],
                                                          userDoc[index][
                                                              'creator userName'],
                                                          userDoc[index][
                                                              'creator fullName'],
                                                          userDoc[index]
                                                              ['date'],
                                                          userDoc[index]
                                                              ['place'],
                                                          userDoc[index]
                                                              ['type'],
                                                          userDoc[index]
                                                              ['description'],
                                                          userDoc[index]
                                                              ['notes'],
                                                          result,
                                                        )
                                                            .timeout(Duration(
                                                                seconds: 5))
                                                            .then((value) {
                                                          final requestSentSnackBar =
                                                              SnackBar(
                                                                  content: Text(
                                                                      'Plan completed Successfully!'));
                                                          globalKey.currentState
                                                              .showSnackBar(
                                                                  requestSentSnackBar);
                                                        }).whenComplete(() {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      } else {
                                                        Navigator.pop(context);
                                                      }
                                                    } else {
                                                      await completePlan(
                                                        ctxt,
                                                        userDoc[index]
                                                            ['isCreator'],
                                                        user.uid,
                                                        userDoc[index]['title'],
                                                        userDoc[index]
                                                            ['creator uid'],
                                                        userDoc[index][
                                                            'creator userName'],
                                                        userDoc[index][
                                                            'creator fullName'],
                                                        userDoc[index]['date'],
                                                        userDoc[index]['place'],
                                                        userDoc[index]['type'],
                                                        userDoc[index]
                                                            ['description'],
                                                        userDoc[index]['notes'],
                                                        result,
                                                      )
                                                          .timeout(Duration(
                                                              seconds: 5))
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
                                                    final requestSentSnackBar =
                                                        SnackBar(
                                                            content: Text(
                                                                'Check Your internet Connection and try again!'));
                                                    globalKey.currentState
                                                        .showSnackBar(
                                                            requestSentSnackBar);
                                                  }
                                                },
                                                rightButtonFun: () async {
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
                                                            userDoc[index][
                                                                'creator userName'],
                                                            userDoc[index][
                                                                'creator fullName'],
                                                            userDoc[index]
                                                                ['title'],
                                                            userDoc[index]
                                                                ['date'],
                                                            userDoc[index]
                                                                ['place'],
                                                            userDoc[index]
                                                                ['type'],
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
                                                                  'Plan is Canceled!'));
                                                      globalKey.currentState
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
                                                    globalKey.currentState
                                                        .showSnackBar(
                                                            requestSentSnackBar);
                                                  }
                                                },
                                              )
                                            : Container()
                                        : Container();
                                  }
                                });
                          });
                    }
                  }),
    );
  }
}
