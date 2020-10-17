import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Algolia_Search/Tag_Friends_Search.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Home_Package/PLans_Home/Plans_Home_Page.dart';
import 'package:youplan/Main_Layout/My_Drawer.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/Model/Users_Data.dart';

import 'PLans_Home/Create_Plan_Page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String typeValue = 'Plans';
  String friendsValue = 'All';
  String dateValue = 'Anytime';
  UserData chooseFriend;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Muser>(context);
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    double filtersSize = width / 27;
    double filtersHeight = height / 23;
    EdgeInsets filtersPadding =
        EdgeInsets.fromLTRB(width / 65, 0, width / 65, 0);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: lightNavy,
        elevation: 5,
        title: Text(
          'Plans & Chall',
          style: kTitleText,
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: filtersHeight,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    padding: filtersPadding,
                    child: DropdownButton<String>(
                        dropdownColor: Colors.grey,
                        underline: Container(),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        value: friendsValue,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: filtersSize,
                        ),
                        onChanged: (String newValue) async {
                          setState(() {
                            friendsValue = newValue;
                          });
                          if (friendsValue == 'Choose a friend') {
                            var result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TagFriendsSearch(
                                  uid: user.uid,
                                ),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                chooseFriend = result;
                              });
                            }
                            print('this is user ' + chooseFriend.userName);
                          } else {
                            setState(() {
                              chooseFriend = null;
                            });
                          }
                        },
                        items: [
                          DropdownMenuItem(
                            value: 'All',
                            child: Text('All'),
                          ),
                          DropdownMenuItem(
                            value: 'Choose a friend',
                            child: Text('Choose a friend'),
                          )
                        ].toList()),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  //TODO:: turn this to type of plan filter
                  // Container(
                  //   padding: filtersPadding,
                  //   child: DropdownButton<String>(
                  //     dropdownColor: Colors.grey,
                  //     underline: Container(),
                  //     value: typeValue,
                  //     icon: Icon(
                  //       Icons.arrow_drop_down,
                  //       color: Colors.white,
                  //     ),
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: filtersSize,
                  //     ),
                  //     onChanged: (String newValue) {
                  //       setState(() {
                  //         typeValue = newValue;
                  //       });
                  //     },
                  //     items: <String>[
                  //       'Plans',
                  //       'Challenges',
                  //     ].map<DropdownMenuItem<String>>((String value) {
                  //       return DropdownMenuItem<String>(
                  //         value: value,
                  //         child: Text(value),
                  //       );
                  //     }).toList(),
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.redAccent,
                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                  //   ),
                  // ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: filtersPadding,
                    child: DropdownButton<String>(
                      dropdownColor: Colors.grey,
                      underline: Container(),
                      value: dateValue,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: filtersSize,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dateValue = newValue;
                        });
                      },
                      items: <String>[
                        'Anytime',
                        'Today',
                        'Tomorrow',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
          SizedBox(
            height: 10,
          ),
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
        backgroundColor: Colors.redAccent,
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
