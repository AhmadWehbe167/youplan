import 'package:flutter/material.dart';
import 'package:youplan/Main_Layout/My_Drawer.dart';
import 'package:youplan/Requests/Challenge_Requests/ChallengeRequestsPage.dart';

import 'Friend_Requests/Friend_Requests_Page.dart';

class RequestsPage extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Requests',
            style: TextStyle(
                color: Colors.black, fontFamily: 'Lobster', fontSize: 30),
          ),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            labelStyle: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
            labelPadding: EdgeInsets.fromLTRB(10, 0, 5, 5),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Text(
                'Friend Requests',
              ),
              // Text(
              //   'Plan Requests',
              // ),
              Text(
                'Challenge Requests',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FriendRequestsPage(),
            // PlanRequestsPage(),
            ChallengeRequestsPage(),
          ],
        ),
        drawer: MyDrawer(),
      ),
    );
  }
}
