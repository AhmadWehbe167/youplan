import 'package:flutter/material.dart';
import 'package:youplan/Memories/Memories_Page.dart';

class Memories extends StatefulWidget {
  @override
  _MemoriesState createState() => _MemoriesState();
}

class _MemoriesState extends State<Memories> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
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
                'Food & Drink',
              ),
              Text(
                'Entertainment',
              ),
              Text(
                'Concerts & Shows',
              ),
              Text(
                'Cultural',
              ),
              Text(
                'Challenges',
              ),
              Text(
                'Other',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MemoriesPage(
              type: 'Food & Drink',
            ),
            MemoriesPage(
              type: 'Entertainment',
            ),
            MemoriesPage(
              type: 'Concerts & Shows',
            ),
            MemoriesPage(
              type: 'Cultural',
            ),
            MemoriesPage(
              type: 'Challenges',
            ),
            MemoriesPage(
              type: 'Other',
            ),
          ],
        ),
      ),
    );
  }
}
