import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youplan/Algolia_Search/Search_Friends_Page.dart';
import 'package:youplan/Requests/Refactored_Widgets/User_Friend_Request.dart';
import 'package:youplan/services/ConnectionCheck.dart';

class FriendsList extends StatefulWidget {
  final String userId;
  const FriendsList({
    this.userId,
  });
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
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
    return Scaffold(
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
          'Friends',
          style: TextStyle(
              color: Colors.black, fontFamily: 'Lobster', fontSize: 30),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchFriendsBar(
                    uid: widget.userId,
                  ),
                ),
              );
            },
            color: Colors.black,
            iconSize: 30,
          ),
        ],
      ),
      body: !isConnected
          ? Container(
              child: Center(
                child: Text(
                    'Page not Found. Check you internet connection and try again'),
              ),
            )
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('Friends')
                  .document(widget.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Container(
                      child: Text('Loading ...'),
                    ),
                  );
                } else {
                  var userDoc = snapshot.data;
                  return ListView.builder(
                    itemCount: userDoc['friends'].length,
                    itemBuilder: (context, index) {
                      return UserFriends(
                        userName: userDoc['friends'][index]['userName'],
                        fullName: userDoc['friends'][index]['fullName'],
                        userId: userDoc['friends'][index]['uid'],
                      );
                    },
                  );
                }
              }),
    );
  }
}
