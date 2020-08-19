import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Algolia_Search/Tag_Friends_Search.dart';
import 'package:youplan/Algolia_Search/display_Search_results.dart';
import 'package:youplan/Authenticate_Screens/Refactored.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Home_Package/Challenges_Home/challenges_functions.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/Model/Users_Data.dart';
import 'package:youplan/shared/Shared_functions.dart';

class CreateChallengePage extends StatefulWidget {
  @override
  _CreateChallengePageState createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  String title;
  String description;
  String notes;
  String friendsError;
  String googlePlacesAPIKey = "AIzaSyDFutHxeyr5we-GrU4d5DkvSKYsSmV_EKY";
  final _formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  List<UserData> taggedFriends = [];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Form(
      key: _formKey,
      child: Scaffold(
        key: globalKey,
        backgroundColor: logoBlue,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Create Challenge',
            style: kTitleText,
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            MyTextField(
              labelTitle: 'Title',
              keyboard: TextInputType.text,
              validate: (val) {
                if (val.length == 0) {
                  return 'This is mandatory';
                } else if (checkTextWithSpace(val)) {
                  return 'Only use: characters, numbers, underscore';
                } else {
                  return null;
                }
              },
              obsecure: false,
              onChan: (val) {
                title = val;
              },
            ),
            SizedBox(
              height: 25,
            ),
            MyTextField(
              labelTitle: 'Description',
              keyboard: TextInputType.text,
              validate: (val) {
                if (checkTextWithSpace(val)) {
                  return 'Only use: characters, numbers, underscore';
                } else {
                  return null;
                }
              },
              obsecure: false,
              onChan: (val) {
                description = val;
              },
            ),
            MyTextField(
              labelTitle: 'Notes',
              keyboard: TextInputType.text,
              validate: (val) {
                if (checkTextWithSpace(val)) {
                  return 'Only use: characters, numbers, underscore';
                } else {
                  return null;
                }
              },
              obsecure: false,
              onChan: (val) {
                notes = val;
              },
            ),
            friendsError != null
                ? Text(
                    friendsError,
                    style: TextStyle(color: Colors.red),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Friends',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                  Row(
                    children: <Widget>[
                      Text(
                        'Add Friend',
                        style: TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () async {
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TagFriendsSearch(
                                uid: user.uid,
                              ),
                            ),
                          );
                          if (result != null) {
                            if (userDataExists(result, taggedFriends)) {
                              return showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('User already added'),
                                        actions: <Widget>[
                                          GestureDetector(
                                            child: Text('Ok'),
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ));
                            } else {
                              setState(() {
                                taggedFriends.add(result);
                              });
                            }
                          }
                        },
                        icon: Icon(Icons.add),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 150,
              child: ListView.builder(
                  itemCount: taggedFriends.length,
                  itemBuilder: (BuildContext contxt, int index) {
                    return DisplayUserData(
                      userData: taggedFriends[index],
                    );
                  }),
            ),
            Center(
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: lightNavy)),
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            Center(child: CircularProgressIndicator()));
                    try {
                      await sendChallenge(
                        context,
                        user.uid,
                        title,
                        taggedFriends,
                        description,
                        notes,
                        () {
                          setState(() {
                            friendsError = 'please choose at least one friend';
                          });
                        },
                      ).timeout(Duration(seconds: 5)).then((value) {
                        final requestSentSnackBar = SnackBar(
                            content: Text('Challenge sent Successfully!'));
                        globalKey.currentState
                            .showSnackBar(requestSentSnackBar);
                      }).whenComplete(() => Navigator.pop(context));
                    } catch (e) {
                      print(e.toString());
                      final requestSentSnackBar = SnackBar(
                          content: Text(
                              'Check Your internet Connection and try again!'));
                      globalKey.currentState.showSnackBar(requestSentSnackBar);
                    }
                  }
                },
                color: Colors.white,
                child: Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
