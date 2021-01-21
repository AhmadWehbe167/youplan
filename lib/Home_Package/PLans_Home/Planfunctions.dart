import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youplan/services/Plan_Requests_database.dart';

Future sendPlan(
    BuildContext context,
    String userID,
    String title,
    String type,
    List taggedFriends,
    DateTime selectedDate,
    String place,
    String description,
    String notes,
    Function typeError,
    Function friendsError) async {
  List namesAvailable =
      await PRDatabaseServices(uid: userID).checkPlanAvailable(title);
  if (type == null) {
    typeError();
  } else if (taggedFriends.isEmpty) {
    friendsError();
  } else if (namesAvailable.contains(title)) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('title already in use'),
              actions: <Widget>[
                GestureDetector(
                  child: Text('Ok'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  } else {
    List<Map<String, String>> stringTaggedFriends = [];
    for (int i = 0; i < taggedFriends.length; i++) {
      stringTaggedFriends.add({
        'uid': taggedFriends[i].uid,
        'userName': taggedFriends[i].userName,
        'fullName': taggedFriends[i].fullName,
      });
    }
    for (int i = 0; i < taggedFriends.length; i++) {
      await PRDatabaseServices(uid: userID).sendPlanRequest(
        taggedFriends[i].uid,
        title,
        type,
        selectedDate,
        place,
        description,
        notes,
        false,
      );
    }
    await PRDatabaseServices(uid: userID).sendPlanRequest(
      userID,
      title,
      type,
      selectedDate,
      place,
      description,
      notes,
      true,
    );
    await PRDatabaseServices(uid: userID)
        .setPlanInfo(title, stringTaggedFriends);
  }
}

Future completePlan(
  BuildContext ctxt,
  bool isCreator,
  String userID,
  String title,
  String creatorID,
  String creatorUserName,
  String creatorFullName,
  Timestamp date,
  String place,
  String type,
  String description,
  String notes,
  result,
) async {
  if (isCreator) {
    if (result != null) {
      await PRDatabaseServices(uid: userID).checkCreatorComplete(
        isCreator,
        creatorID,
        creatorUserName,
        creatorFullName,
        title,
        date,
        place,
        type,
        description,
        notes,
        result ?? [],
      );
    }
  } else {
    await PRDatabaseServices(uid: userID).checkCreatorComplete(
      isCreator,
      creatorID,
      creatorUserName,
      creatorFullName,
      title,
      date,
      place,
      type,
      description,
      notes,
      result ?? [],
    );
  }
}

bool hasField(AsyncSnapshot snap, String field) {
  try {
    var a = snap.data[field];
    return true;
  } catch (Error) {
    return false;
  }
}
