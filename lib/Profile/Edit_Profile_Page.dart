import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.green,
              size: 35,
            ),
            onPressed: () {
              Navigator.pop(context); //TODO:Submit Changes
            },
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 40,
              ),
              Container(
                height: 200,
                child: Image.asset('images/user.png'),
              ),
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                  size: 40,
                ),
                onPressed: () {
                  print('Camera Icon Pressed');
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: TextStyle(fontSize: 30),
                ),
                Divider(
                  thickness: 5,
                  height: 70,
                ),
                Text(
                  'UserName',
                  style: TextStyle(fontSize: 30),
                ),
                Divider(
                  thickness: 5,
                  height: 70,
                ),
                Text(
                  'Email',
                  style: TextStyle(fontSize: 30),
                ),
                Divider(
                  thickness: 5,
                  height: 70,
                ),
                Text(
                  'Bio',
                  style: TextStyle(fontSize: 30),
                ),
                Divider(
                  thickness: 5,
                  height: 70,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
