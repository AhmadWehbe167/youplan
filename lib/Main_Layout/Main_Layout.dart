import 'package:flutter/material.dart';
import 'package:youplan/Explore/Explore_Page.dart';
import 'package:youplan/Home_Package/Home_Page.dart';
import 'package:youplan/Memories/Memories.dart';
import 'package:youplan/Requests/Requests_Page.dart';

class MainPageLayout extends StatefulWidget {
  @override
  _MainPageLayoutState createState() => _MainPageLayoutState();
}

class _MainPageLayoutState extends State<MainPageLayout> {
  int _selectedIndex = 0;
  static const TextStyle _style = TextStyle(
    fontFamily: 'Lobster',
    fontSize: 70,
  );
  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ExplorePage(),
    RequestsPage(),
    Memories(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType
            .fixed, // so that we can display more than 3 items in navigation bar
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Requests'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.memory),
            title: Text('Memories'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
