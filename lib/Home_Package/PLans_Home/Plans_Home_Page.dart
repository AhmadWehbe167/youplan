import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Home_Package/PLans_Home/Attendees_Check_Box.dart';
import 'package:youplan/Home_Package/PLans_Home/Planfunctions.dart';
import 'package:youplan/Home_Package/Refactored_Widgets/plan_card.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/Model/Users_Data.dart';
import 'package:youplan/services/ConnectionCheck.dart';
import 'package:youplan/services/Plan_Requests_database.dart';

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
  var loading = true;
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
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: Colors.white,
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
                  stream: Firestore.instance
                      .collection('Plans')
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
                    } else if (snapshot.data['plans'].length == 0) {
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
                              'Plans',
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
                      var userDoc = snapshot.data['plans'];
                      return ListView.builder(
                          itemCount: snapshot.data['plans'].length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return StreamBuilder(
                                stream: Firestore.instance
                                    .collection('planNames')
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
