import 'package:flutter/material.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Main_Layout/My_Drawer.dart';

class MemoriesPage extends StatefulWidget {
  @override
  _MemoriesPageState createState() => _MemoriesPageState();
}

class _MemoriesPageState extends State<MemoriesPage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: headerBottomColor,
        elevation: 0,
        title: Text(
          'Memories',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Lobster',
            fontSize: width * 0.09,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              //TODO::Filter results
            },
          )
        ],
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            Opacity(
              opacity: 0.75,
              child: Container(
                height: height * 0.4,
                width: width * 0.8,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/Memories.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            Opacity(
              opacity: 0.75,
              child: Text(
                'No memories yet. Complete',
                style: TextStyle(
                  color: Color(0xFF9CC3CC),
                  fontSize: width * 0.07,
                ),
              ),
            ),
            Opacity(
              opacity: 0.75,
              child: Text(
                'a plan to get one.',
                style: TextStyle(
                  color: Color(0xFF9CC3CC),
                  fontSize: width * 0.07,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.12,
            ),
          ],
        ),
      ),
    );
  }
}
