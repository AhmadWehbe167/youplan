import 'package:flutter/material.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Main_Layout/My_Drawer.dart';

import 'Friend_Requests/Friend_Requests_Page.dart';
import 'PLan_Requests/PLan_Requests_Page.dart';

class RequestsPage extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: headerBottomColor,
          elevation: 5,
          title: Text(
            'Requests',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Lobster',
                fontSize: size.width * 0.09),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: size.width * 0.07,
              fontWeight: FontWeight.bold,
            ),
            indicatorColor: Colors.white,
            labelPadding: EdgeInsets.only(bottom: size.width * 0.015),
            unselectedLabelColor: Colors.grey[300],
            tabs: [
              Text(
                'Friends',
              ),
              Text(
                'Plans',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FriendRequestsPage(),
            PlanRequestsPage(),
          ],
        ),
        drawer: MyDrawer(),
      ),
    );
  }
}
