import 'package:flutter/material.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Home_Package/Challenges_Home/Challenges_Home_Page.dart';
import 'package:youplan/Home_Package/PLans_Home/Plans_Home_Page.dart';
import 'package:youplan/Main_Layout/My_Drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            'My Plans',
            style: kTitleText,
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.black,
            labelStyle: kLabelStyle,
            labelPadding: EdgeInsets.all(5),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: kLabelStyle,
            tabs: [
              Text('Plans'),
              Text('Challenges'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PlansHomePage(),
            ChallengesHomePage(),
          ],
        ),
        drawer: MyDrawer(),
      ),
    );
  }
}