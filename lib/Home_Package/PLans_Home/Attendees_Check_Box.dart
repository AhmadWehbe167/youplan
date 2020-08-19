import 'package:flutter/material.dart';
import 'package:youplan/services/Plan_Requests_database.dart';
import 'package:youplan/shared/loading.dart';

class AttendeesCheckBox extends StatefulWidget {
  final String senderID;
  final String title;
  const AttendeesCheckBox({this.senderID, this.title});
  @override
  _AttendeesCheckBoxState createState() => _AttendeesCheckBoxState();
}

class _AttendeesCheckBoxState extends State<AttendeesCheckBox> {
  Map<Map, bool> values = {};
  List accepted = [];
  List ignoredUsers = [];
  bool noUsers = false;
  bool loading = true;
  Future getAcceptedUsers() async {
    accepted = await PRDatabaseServices(uid: widget.senderID)
        .getAcceptedUsers(widget.title);
    for (int i = 0; i < accepted.length; i++) {
      setState(() {
        values[accepted[i]] = false;
      });
    }
    if (accepted.length == 0) {
      setState(() {
        noUsers = true;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAcceptedUsers();
    Future.delayed(
      Duration(milliseconds: 500),
      () {
        setState(() {
          loading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? WhiteLoading()
        : noUsers
            ? Scaffold(
                body: Center(
                  child: Text('No users to choose left'),
                ),
                bottomSheet: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      color: Colors.green,
                      onPressed: () {
                        Navigator.pop(context, []);
                      },
                    ),
                  ],
                ),
              )
            : Scaffold(
                bottomSheet: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context, null);
                        },
                        color: Colors.red,
                      ),
                      FlatButton(
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          values.forEach((key, value) {
                            if (value == false) {
                              ignoredUsers.add(key);
                            }
                          });
                          Navigator.pop(context, ignoredUsers);
                        },
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
                body: ListView(
                  children: values.keys.map((Map key) {
                    return CheckboxListTile(
                      title: Text(key['fullName'] + ' ( ${key['userName']} )'),
                      value: values[key],
                      onChanged: (bool value) {
                        setState(() {
                          values[key] = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              );
  }
}
