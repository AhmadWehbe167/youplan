import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Home_Package/PLans_Home/Planfunctions.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/Requests/PLan_Requests/ViewPlan.dart';
import 'package:youplan/services/Plan_Requests_database.dart';

final globalKey = GlobalKey<ScaffoldState>();

class PlanRequestsPage extends StatefulWidget {
  @override
  _PlanRequestsPageState createState() => _PlanRequestsPageState();
}

class _PlanRequestsPageState extends State<PlanRequestsPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Muser>(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: background,
      key: globalKey,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Requests')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              //TODO:: deal with Loading
              return Center(
                child: Text('no data'),
              );
            } else if (hasField(snapshot, 'friends') &&
                snapshot.data['friends'].length == 0) {
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
                        width: width * 0.8,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/NoPlanReq.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Opacity(
                      opacity: 0.75,
                      child: Text(
                        'No plan requests in',
                        style: TextStyle(
                          color: Color(0xFF9CC3CC),
                          fontSize: width * 0.075,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.75,
                      child: Text(
                        'the meantime',
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
                      Timestamp selectedDate = userDoc[index]['date'];
                      var place = userDoc[index]['place'];
                      var type = userDoc[index]['type'];
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewPlan(
                                    index: index,
                                    uid: uid,
                                    userName: userName,
                                    fullName: fullName,
                                    title: title,
                                    type: type,
                                    selectedDate: DateFormat('yMd')
                                        .format(selectedDate.toDate()),
                                    place: place ?? '',
                                    description: description ?? '',
                                    notes: notes ?? '',
                                    isCreator: isCreator,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: <Widget>[
                                // PlanCard(
                                //   title: title,
                                //   type: type,
                                //   date: selectedDate.toDate(),
                                //   locationDescription: place ?? '',
                                //   isPLan: true,
                                //   elevate: true,
                                // ),
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
                                                await PRDatabaseServices(
                                                        uid: user.uid)
                                                    .acceptPlanRequest(
                                                      uid,
                                                      userName,
                                                      fullName,
                                                      title,
                                                      selectedDate,
                                                      place,
                                                      type,
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
                                                              'Plan Accepted Successfully!'));
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
                                                await PRDatabaseServices(
                                                        uid: user.uid)
                                                    .rejectPlanRequest(
                                                      uid,
                                                      userName,
                                                      fullName,
                                                      userDoc[index]['title'],
                                                      selectedDate,
                                                      place,
                                                      type,
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
                                                              'Plan Rejected!'));
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
//                          PlanRequestWidget(
//                            userDoc: userDoc,
//                            index: index,
//                            fun: () {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                  builder: (context) => ViewPlan(
//                                    index: index,
//                                    uid: userDoc[index]['creator uid'],
//                                    userName: userDoc[index]
//                                        ['creator userName'],
//                                    fullName: userDoc[index]
//                                        ['creator fullName'],
//                                    title: userDoc[index]['title'],
//                                    type: userDoc[index]['type'],
//                                    selectedDate: DateFormat('yMd').format(
//                                        userDoc[index]['date'].toDate()),
//                                    place: userDoc[index]['place'] ?? '',
//                                    description:
//                                        userDoc[index]['description'] ?? '',
//                                    notes: userDoc[index]['notes'] ?? '',
//                                    isCreator: userDoc[index]['isCreator'],
//                                  ),
//                                ),
//                              );
//                            },
//                            title: userDoc[index]['title'],
//                            type: userDoc[index]['type'],
//                            description: userDoc[index]['description'],
//                            selectedDate: userDoc[index]['date'],
//                            place: userDoc[index]['place'],
//                            notes: userDoc[index]['notes'],
//                            isCreator: userDoc[index]['isCreator'],
//                            uid: userDoc[index]['creator uid'],
//                            fullName: userDoc[index]['creator fullName'],
//                            userName: userDoc[index]['creator userName'],
//                          ),
                        ),
                      );
                    });
              }
            }
          }),
    );
  }
}
//
//class PlanRequestWidget extends StatelessWidget {
//  const PlanRequestWidget({
//    Key key,
//    @required this.userDoc,
//    @required this.index,
//    @required this.fun,
//    this.title,
//    this.type,
//    this.uid,
//    this.place,
//    this.notes,
//    this.description,
//    this.selectedDate,
//    this.isCreator,
//    this.userName,
//    this.fullName,
//    this.friendsAccepted,
//    this.friendsInvited,
//  }) : super(key: key);
//  final String uid;
//  final String userName;
//  final String fullName;
//  final String title;
//  final String type;
//  final Timestamp selectedDate;
//  final String place;
//  final String description;
//  final String notes;
//  final List friendsInvited;
//  final List friendsAccepted;
//  final bool isCreator;
//  final userDoc;
//  final index;
//  final Function fun;
//
//  @override
//  Widget build(BuildContext context) {
//    final user = Provider.of<User>(context);
//    return GestureDetector(
//      onTap: fun,
//      child: Column(
//        children: <Widget>[
//          PlanChallCard(
//            imageTitle: 'restaurant',
//            title: userDoc[index]['title'],
//            type: userDoc[index]['type'],
//            date: userDoc[index]['date'].toDate(),
//            locationDescription: userDoc[index]['place'] ?? '',
//            isPLan: true,
//            elevate: true,
//          ),
//          userDoc[index]['isCreator'] == false
//              ? Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  children: <Widget>[
//                    RaisedButton(
//                      elevation: 5,
//                      onPressed: () async {
//                        showDialog(
//                            context: context,
//                            builder: (context) =>
//                                Center(child: CircularProgressIndicator()));
//                        try {
//                          await PRDatabaseServices(uid: user.uid)
//                              .acceptPlanRequest(
//                                  uid,
//                                  userName,
//                                  fullName,
//                                  title,
//                                  selectedDate,
//                                  place,
//                                  type,
//                                  description,
//                                  notes,
//                                  isCreator)
//                              .timeout(Duration(seconds: 5))
//                              .then((value) {
//                            final requestSentSnackBar = SnackBar(
//                                content: Text('Plan Accepted Successfully!'));
//                            globalKey.currentState
//                                .showSnackBar(requestSentSnackBar);
//                          }).whenComplete(() {
//                            Navigator.pop(context);
//                          });
//                        } catch (e) {
//                          print(e.toString());
//                          final requestSentSnackBar = SnackBar(
//                              content: Text(
//                                  'Check Your internet Connection and try again!'));
//                          globalKey.currentState
//                              .showSnackBar(requestSentSnackBar);
//                        }
//                      },
//                      child: Text(
//                        'Accept',
//                        style: TextStyle(color: Colors.white),
//                      ),
//                      color: Colors.green,
//                    ),
//                    RaisedButton(
//                      elevation: 5,
//                      onPressed: () async {
//                        showDialog(
//                            context: context,
//                            builder: (context) =>
//                                Center(child: CircularProgressIndicator()));
//                        try {
//                          await PRDatabaseServices(uid: user.uid)
//                              .rejectPlanRequest(
//                                  uid,
//                                  userName,
//                                  fullName,
//                                  title,
//                                  selectedDate,
//                                  place,
//                                  type,
//                                  description,
//                                  notes,
//                                  isCreator)
//                              .timeout(Duration(seconds: 5))
//                              .then((value) {
//                            final requestSentSnackBar =
//                                SnackBar(content: Text('Plan Rejected!'));
//                            globalKey.currentState
//                                .showSnackBar(requestSentSnackBar);
//                          }).whenComplete(() {
//                            Navigator.pop(context);
//                          });
//                        } catch (e) {
//                          print(e.toString());
//                          final requestSentSnackBar = SnackBar(
//                              content: Text(
//                                  'Check Your internet Connection and try again!'));
//                          globalKey.currentState
//                              .showSnackBar(requestSentSnackBar);
//                        }
//                      },
//                      child: Text(
//                        'Reject',
//                        style: TextStyle(color: Colors.white),
//                      ),
//                      color: Colors.red,
//                    ),
//                  ],
//                )
//              : Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Row(
//                    children: <Widget>[
//                      Expanded(
//                        flex: 6,
//                        child: Text(
//                          'Friends accepted your request',
//                          style: TextStyle(
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                      ),
//                      Expanded(
//                        flex: 2,
//                        child: SizedBox(),
//                      ),
//                      Expanded(
//                        child: Text(
//                          '0',
//                          style: TextStyle(
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//        ],
//      ),
//    );
//  }
//  }
//}
