import 'package:flutter/material.dart';
import 'package:youplan/services/Challenge_Requests_database.dart';

Future sendChallenge(
    BuildContext context,
    String userID,
    String title,
    List taggedFriends,
    String description,
    String notes,
    Function friendsError) async {
  List namesAvailable =
      await CRDatabaseServices(uid: userID).checkChallengeAvailable(title);
  if (taggedFriends.isEmpty) {
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
      await CRDatabaseServices(uid: userID).sendChallengeRequest(
        taggedFriends[i].uid,
        title,
        description,
        notes,
        false,
      );
    }
    await CRDatabaseServices(uid: userID).sendChallengeRequest(
      userID,
      title,
      description,
      notes,
      true,
    );
    await CRDatabaseServices(uid: userID)
        .setChallengeInfo(title, stringTaggedFriends);
  }
}
