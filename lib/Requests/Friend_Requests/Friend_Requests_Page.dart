import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Home_Package/PLans_Home/Planfunctions.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/Profile/Profile_Page.dart';
import 'package:youplan/services/ConnectionCheck.dart';
import 'package:youplan/services/Friend_Requests_database.dart';

class FriendRequestsPage extends StatefulWidget {
  @override
  _FriendRequestsPageState createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  bool isConnected = true;
  getConnection() async {
    isConnected = await checkConnection();
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
    final globalKey = GlobalKey<ScaffoldState>();
    final user = Provider.of<Muser>(context);
    return !isConnected
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              //TODO:: deal with connection error
              child: Text(
                'Page Not Found. Check your internet Connection and try again',
                style: TextStyle(fontSize: 20),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: background,
            key: globalKey,
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Requests')
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Scaffold(
                      //TODO::deal with Loading
                      backgroundColor: Colors.white,
                      body: Center(
                        child: Text(
                          'Loading ... ',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
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
                              width: width * 0.9,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/NoFrReq.png'),
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
                              'No friend requests in',
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
                    var userDoc = snapshot.data;
                    return ListView.builder(
                      itemCount: userDoc['friends'].length,
                      itemBuilder: (context, index) {
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
                                          userID: userDoc['friends'][index]
                                              ['uid'],
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
                                          userID: userDoc['friends'][index]
                                              ['uid'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${userDoc['friends'][index]['fullName']}',
                                        style: TextStyle(fontSize: 23),
                                      ),
                                      Text(
                                        '${userDoc['friends'][index]['userName']}',
                                        style: TextStyle(fontSize: 23),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: FlatButton(
                                          padding: EdgeInsets.all(0),
                                          onPressed: () async {
                                            try {
                                              await FRDatabaseService(
                                                      uid: user.uid)
                                                  .acceptFriendRequest(
                                                      userDoc['friends'][index]
                                                          ['uid'])
                                                  .timeout(Duration(seconds: 5))
                                                  .then((value) {
                                                final requestSentSnackBar =
                                                    SnackBar(
                                                        content: Text(
                                                            'You are friends now!'));
                                                globalKey.currentState
                                                    .showSnackBar(
                                                        requestSentSnackBar);
                                              });
                                            } catch (e) {
                                              final requestSentSnackBar = SnackBar(
                                                  content: Text(
                                                      'Check your internet connection and try again'));
                                              globalKey.currentState
                                                  .showSnackBar(
                                                      requestSentSnackBar);
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
                                                  .rejectFriendRequest(
                                                      userDoc['friends'][index]
                                                          ['uid']);
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
//                      UserFriendRequest(
//                      userName: userDoc['friends'][index]['userName'],
//                      fullName: userDoc['friends'][index]['fullName'],
//                      userId: userDoc['friends'][index]['uid'],
//                      globalKey: globalKey,
//                    );
                      },
                    );
                  }
                }),
          );
  }
}
