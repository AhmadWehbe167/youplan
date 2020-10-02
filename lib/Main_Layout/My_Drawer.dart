import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/Profile/Edit_Profile_Page.dart';
import 'package:youplan/Profile/Profile_Page.dart';
import 'package:youplan/services/auth.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Drawer(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 100,
              child: Align(
                child: Image.asset('images/user.png'),
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ReminderPage()),
              // );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 0, 5),
              child: Text('Reminder'),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage(
                          userID: user.uid,
                        )),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 0, 5),
              child: Text('Profile Page'),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 0, 5),
              child: Text('Edit Profile'),
            ),
          ),
          GestureDetector(
            onTap: () {
              AuthServices().signOut();
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 0, 5),
              child: Text('Sign Out'),
            ),
          ),
        ],
      ),
    );
  }
}
