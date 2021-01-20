import 'package:flutter/material.dart';
import 'package:youplan/Algolia_Search/Search_Users_Page.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Home_Package/Home_Page.dart';
import 'package:youplan/Memories/Memories.dart';
import 'package:youplan/Requests/Requests_Page.dart';

class MainPageLayout extends StatefulWidget {
  @override
  _MainPageLayoutState createState() => _MainPageLayoutState();
}

class _MainPageLayoutState extends State<MainPageLayout> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      HomePage(),
      SearchUsersBar(),
      RequestsPage(),
      MemoriesPage(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: headerBottomColor,
        unselectedItemColor: Color(0xFF71A5B2),
        selectedIconTheme: IconThemeData(color: Orange),
        selectedLabelStyle: TextStyle(color: Colors.white),
        currentIndex: _selectedIndex,
        selectedItemColor: Orange,
        onTap: _onItemTapped,
        type: BottomNavigationBarType
            .fixed, // so that we can display more than 3 items in navigation bar
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.memory),
            label: 'Memories',
          ),
        ],
      ),
    );
  }
}
