import 'package:flutter/material.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Home_Package/PLans_Home/Plans_Home_Page.dart';
import 'package:youplan/Main_Layout/My_Drawer.dart';
import 'package:youplan/Model/Users_Data.dart';

import 'PLans_Home/Create_Plan_Page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String friendsValue = 'All';
  String dateValue = 'Anytime';
  UserData chooseFriend;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: headerBottomColor,
        elevation: 5,
        title: Text(
          'Plans',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Lobster',
              fontSize: size.width * 0.09),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              //TODO:Filter results PopUp
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: Column(
        children: <Widget>[
          chooseFriend != null
              ? FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    chooseFriend.userName,
                    style: TextStyle(
                      fontFamily: 'ConcertOne',
                      fontSize: 25,
                      color: lightNavy,
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: PlansHomePage(
              friend: chooseFriend,
              time: dateValue,
              isAll: chooseFriend == null,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Orange,
        elevation: 5,
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePlanPage(),
            ),
          );
        },
      ),
    );
  }
}
