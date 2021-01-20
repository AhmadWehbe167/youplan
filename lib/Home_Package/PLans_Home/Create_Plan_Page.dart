import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Algolia_Search/Tag_Friends_Search.dart';
import 'package:youplan/Algolia_Search/display_Search_results.dart';
import 'package:youplan/Authenticate_Screens/Auth_Services/RefactoredWidgets_Functions.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Home_Package/PLans_Home/Planfunctions.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/Model/Users_Data.dart';
import 'package:youplan/shared/Shared_functions.dart';

class CreatePlanPage extends StatefulWidget {
  @override
  _CreatePlanPageState createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends State<CreatePlanPage> {
  String title;
  String type;
  DateTime selectedDate = DateTime.now();
  String place;
  String description;
  String notes;
  String typeError;
  String friendsError;
  String googlePlacesAPIKey = "AIzaSyDFutHxeyr5we-GrU4d5DkvSKYsSmV_EKY";
  final _formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  List<UserData> taggedFriends = [];
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Muser>(context);
    var size = MediaQuery.of(context).size;
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
            'Create Plan',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Lobster',
                fontSize: size.width * 0.1),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            AuthTextField(
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
              obscure: false,
              onChan: (val) {
                title = val;
              },
            ),
            typeError != null
                ? Text(
                    typeError,
                    style: TextStyle(color: Colors.red),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
              child: DropdownButton(
                hint: Text(
                  'Type',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white, fontSize: 15),
                elevation: 5,
                isDense: true,
                isExpanded: true,
                underline: Container(),
                dropdownColor: Orange,
                items: planType,
                value: type,
                onChanged: (String newValue) {
                  setState(() {
                    type = newValue;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
              child: GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            GestureDetector(
                onTap: () async {
                  try {
                    Prediction p = await PlacesAutocomplete.show(
                        context: context,
                        mode: Mode.overlay,
                        apiKey: googlePlacesAPIKey,
                        language: "en",
                        components: [
                          Component(Component.country, "lb"),
                        ]);
                    setState(() {
                      place = p.description;
                    });
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
                  child: Text(
                    place == null ? 'place' : place,
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            SizedBox(
              height: 25,
            ),
            AuthTextField(
              labelTitle: 'Description',
              keyboard: TextInputType.text,
              validate: (val) {
                if (checkTextWithSpace(val)) {
                  return 'Only use: characters, numbers, underscore';
                } else {
                  return null;
                }
              },
              obscure: false,
              onChan: (val) {
                description = val;
              },
            ),
            AuthTextField(
              labelTitle: 'Notes',
              keyboard: TextInputType.text,
              validate: (val) {
                if (checkTextWithSpace(val)) {
                  return 'Only use: characters, numbers, underscore';
                } else {
                  return null;
                }
              },
              obscure: false,
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
                      await sendPlan(
                          context,
                          user.uid,
                          title,
                          type,
                          taggedFriends,
                          selectedDate,
                          place,
                          description,
                          notes, () {
                        setState(() {
                          typeError = 'please choose a type';
                        });
                      }, () {
                        setState(() {
                          typeError = null;
                          friendsError = 'Please choose at least one friend';
                        });
                      }).timeout(Duration(seconds: 5)).then((value) {
                        final requestSentSnackBar =
                            SnackBar(content: Text('Plan sent Successfully!'));
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
