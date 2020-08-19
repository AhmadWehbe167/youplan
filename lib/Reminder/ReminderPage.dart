import 'package:flutter/material.dart';
import 'package:youplan/Home_Package/Refactored_Widgets/plan_card.dart';

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Reminder',
            style: TextStyle(
                color: Colors.black, fontFamily: 'Lobster', fontSize: 30),
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            labelStyle: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
            labelPadding: EdgeInsets.all(5),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Text(
                'Plans',
              ),
              Text(
                'Birthdays',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Tomorrow',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                Divider(),
                PlanCard(
                  imageTitle: 'restaurant',
                  title: 'Ellysuim',
                  type: 'Restaurant',
                  date: DateTime.now(),
                  locationDescription: 'Zebdein, Nabatieh',
                  isPLan: true,
                  elevate: true,
                ),
                PlanCard(
                  imageTitle: 'restaurant',
                  title: 'Eatvite',
                  type: 'Restaurant',
                  date: DateTime.now(),
                  locationDescription: 'Zebdein, Nabatieh',
                  isPLan: true,
                  elevate: true,
                ),
              ],
            ),
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'After a week',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                Divider(),
                PlanCard(
                  imageTitle: 'birthday',
                  title: 'Nono',
                  type: 'Birthday',
                  date: DateTime.now(),
                  locationDescription: 'Hamra, Beirut',
                  isPLan: true,
                  elevate: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
