import 'package:flutter/material.dart';
import 'package:youplan/Algolia_Search/Search_Users_Page.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Main_Layout/My_Drawer.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Explore',
          style: kTitleText,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchUsersBar(),
                  ),
                );
              },
              icon: Icon(
                Icons.search,
                color: Colors.black,
                size: 35,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          ExploreButtons(),
          ExploreButtons(),
        ],
      ),
      drawer: MyDrawer(),
    );
  }
}

class ExploreButtons extends StatelessWidget {
  const ExploreButtons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundedContainer(
          title: 'Food & Drink',
          fontSize: 40,
          borderRadius: 15,
          containerHeight: 200,
        ),
        Row(
          children: [
            SubButton(
              title: 'Restaurant',
              buttonWidth: 100,
            ),
            SubButton(
              title: 'Coffee',
              buttonWidth: 70,
            ),
            SubButton(
              title: 'Bar',
              buttonWidth: 70,
            ),
            SubButton(
              title: 'Crepe',
              buttonWidth: 70,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: RoundedContainer(
                  title: 'Concerts',
                  containerHeight: 150,
                  borderRadius: 15,
                  fontSize: 30),
            ),
            Expanded(
              child: RoundedContainer(
                  title: 'Shows',
                  containerHeight: 150,
                  borderRadius: 15,
                  fontSize: 30),
            ),
          ],
        ),
        Row(
          children: [
            SubButton(
              title: 'Restaurant',
              buttonWidth: 100,
            ),
            SubButton(
              title: 'Coffee',
              buttonWidth: 70,
            ),
            SubButton(
              title: 'Bar',
              buttonWidth: 70,
            ),
            SubButton(
              title: 'Crepe',
              buttonWidth: 70,
            ),
          ],
        ),
      ],
    );
  }
}

class RoundedContainer extends StatelessWidget {
  final String title;
  final double borderRadius;
  final double containerHeight;
  final double fontSize;
  const RoundedContainer({
    @required this.title,
    @required this.borderRadius,
    @required this.containerHeight,
    @required this.fontSize,
    Key key,
  })  : assert(title != null),
        assert(borderRadius != null),
        assert(containerHeight != null),
        assert(fontSize != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: containerHeight,
        decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
            child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )),
      ),
    );
  }
}

class SubButton extends StatelessWidget {
  final String title;
  final double buttonWidth;
  const SubButton({
    Key key,
    this.buttonWidth,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        height: 30,
        width: buttonWidth,
        decoration: BoxDecoration(
          color: Colors.grey[500],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
            child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )),
      ),
    );
  }
}
