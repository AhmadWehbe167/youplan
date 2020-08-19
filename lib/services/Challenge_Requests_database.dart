import 'package:cloud_firestore/cloud_firestore.dart';

import 'collections_references.dart';

class CRDatabaseServices {
  final String uid;
  CRDatabaseServices({this.uid});

  Future sendChallengeRequest(
    String receiverId,
    String title,
    String description,
    String notes,
    bool isCreator, {
    List<Map<String, String>> friendsInvited,
    List<Map<String, String>> friendsAccepted,
  }) async {
    final DocumentSnapshot userSnapshot =
        await usersReference.document(uid).get();
    String myUserName = await userSnapshot.data['userName'];
    String myFullName = await userSnapshot.data['fullName'];
    return await requestsReference.document(receiverId).updateData({
      'challenges': FieldValue.arrayUnion([
        {
          'creator uid': uid,
          'creator userName': myUserName,
          'creator fullName': myFullName,
          'title': title,
          'description': description,
          'notes': notes,
          'isCreator': isCreator,
        }
      ]),
    });
  }

  Future checkChallengeAvailable(
    String title,
  ) async {
    DocumentSnapshot doc = await Firestore.instance
        .collection('challengeNames')
        .document(uid)
        .get();
    return List.from(doc.data['Names']);
  }

  Future setChallengeInfo(String title, List friendsInvited) async {
    await challengeNamesReference.document(uid).updateData({
      'Names': FieldValue.arrayUnion([title]),
      '$title Invited Friends': friendsInvited,
      '$title Accepted Friends': [],
      '$title Rejected Friends': [],
      '$title Completed Friends': [],
      '$title Canceled Friends': [],
      '$title Done by Creator': false,
    });
  }

  Future rejectChallengeRequest(
    String senderId,
    String senderUserName,
    String senderFullName,
    String title,
    String description,
    String notes,
    bool isCreator,
  ) async {
    final DocumentSnapshot userSnapshot =
        await usersReference.document(uid).get();
    final DocumentSnapshot challengeInfoSnapshot =
        await challengeNamesReference.document(senderId).get();
    String myUserName = await userSnapshot.data['userName'];
    String myFullName = await userSnapshot.data['fullName'];
    await requestsReference.document(uid).updateData({
      'challenges': FieldValue.arrayRemove([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'description': description,
          'isCreator': isCreator,
          'notes': notes,
          'title': title,
        }
      ])
    });
    await challengeNamesReference.document(senderId).updateData({
      '$title Invited Friends': FieldValue.arrayRemove([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
    await challengeNamesReference.document(senderId).updateData({
      '$title Rejected Friends': FieldValue.arrayUnion([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
    if (challengeInfoSnapshot.data['$title Invited Friends'].length == 0) {
      await requestsReference.document(senderId).updateData({
        'challenges': FieldValue.arrayRemove([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'description': description,
            'isCreator': true,
            'notes': notes,
            'title': title,
          }
        ])
      });
    }
  }

  Future acceptChallengeRequest(
    String senderId,
    String senderUserName,
    String senderFullName,
    String title,
    String description,
    String notes,
    bool isCreator,
  ) async {
    final DocumentSnapshot challengeInfoSnapshot =
        await challengeNamesReference.document(senderId).get();
    await requestsReference.document(uid).updateData({
      'challenges': FieldValue.arrayRemove([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'description': description,
          'isCreator': isCreator,
          'notes': notes,
          'title': title,
        }
      ])
    });
    await challengesReference.document(uid).updateData({
      'challenges': FieldValue.arrayUnion([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'description': description,
          'isCreator': isCreator,
          'notes': notes,
          'title': title,
        }
      ])
    });
    if (challengeInfoSnapshot.data['$title Accepted Friends'].length == 0) {
      await requestsReference.document(senderId).updateData({
        'challenges': FieldValue.arrayRemove([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'description': description,
            'isCreator': true,
            'notes': notes,
            'title': title,
          }
        ])
      });
      await challengesReference.document(senderId).updateData({
        'challenges': FieldValue.arrayUnion([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'description': description,
            'isCreator': true,
            'notes': notes,
            'title': title,
          }
        ])
      });
    }
    final DocumentSnapshot userSnapshot =
        await usersReference.document(uid).get();
    String myUserName = await userSnapshot.data['userName'];
    String myFullName = await userSnapshot.data['fullName'];
    await challengeNamesReference.document(senderId).updateData({
      '$title Invited Friends': FieldValue.arrayRemove([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
    await challengeNamesReference.document(senderId).updateData({
      '$title Accepted Friends': FieldValue.arrayUnion([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
  }

  Future completeChallengeReceiver(
    String senderId,
    String senderUserName,
    String senderFullName,
    String title,
    String description,
    String notes,
  ) async {
    final DocumentSnapshot userSnapshot =
        await usersReference.document(uid).get();
    final DocumentSnapshot challengeNamesSnapshot =
        await challengeNamesReference.document(senderId).get();
    String myUserName = await userSnapshot.data['userName'];
    String myFullName = await userSnapshot.data['fullName'];
    bool isCreatorDone =
        await challengeNamesSnapshot.data['$title Done by Creator'];
    await challengeNamesReference.document(senderId).updateData({
      '$title Accepted Friends': FieldValue.arrayRemove([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
    await challengeNamesReference.document(senderId).updateData({
      '$title Completed Friends': FieldValue.arrayUnion([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
    await challengesReference.document(uid).updateData({
      'challenges': FieldValue.arrayRemove([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'description': description,
          'isCreator': false,
          'notes': notes,
          'title': title,
        }
      ])
    });
    if (isCreatorDone) {
      final DocumentSnapshot challengeNamesSnapshot =
          await challengeNamesReference.document(senderId).get();
      List completedUsers =
          List.from(challengeNamesSnapshot['$title Completed Friends']);
      List noAnswer =
          List.from(challengeNamesSnapshot['$title Invited Friends']);
      List rejectedFriends =
          List.from(challengeNamesSnapshot['$title Rejected Friends']);
      List canceledFriends =
          List.from(challengeNamesSnapshot['$title Canceled Friends']);
      List justAccepted =
          List.from(challengeNamesSnapshot['$title Accepted Friends']);
      await memoriesReference
          .document(uid)
          .collection('categories')
          .document('Challenges')
          .updateData({
        'challenges': FieldValue.arrayUnion([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'description': description,
            'isCreator': false,
            'notes': notes,
            'title': title,
            'noAnswer Friends': noAnswer,
            'rejected': rejectedFriends,
            'completed': completedUsers + justAccepted,
            'canceled': canceledFriends,
          }
        ])
      });
      if (justAccepted.length == 0) {
        await challengeNamesReference.document(uid).updateData({
          'Names': FieldValue.arrayRemove([title]),
          '$title Invited Friends': FieldValue.delete(),
          '$title Accepted Friends': FieldValue.delete(),
          '$title Rejected Friends': FieldValue.delete(),
          '$title Completed Friends': FieldValue.delete(),
          '$title Canceled Friends': FieldValue.delete(),
          '$title Done by Creator': FieldValue.delete(),
        });
      }
    }
  }

  Future cancelChallengeReceiver(
    String senderId,
    String senderUserName,
    String senderFullName,
    String title,
    String description,
    String notes,
  ) async {
    final DocumentSnapshot userSnapshot =
        await usersReference.document(uid).get();
    final DocumentSnapshot challengeNamesSnapshot =
        await challengeNamesReference.document(senderId).get();
    String myUserName = await userSnapshot.data['userName'];
    String myFullName = await userSnapshot.data['fullName'];
    bool isCreatorDone =
        await challengeNamesSnapshot.data['$title Done by Creator'];
    await challengeNamesReference.document(senderId).updateData({
      '$title Accepted Friends': FieldValue.arrayRemove([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
    await challengeNamesReference.document(senderId).updateData({
      '$title Canceled Friends': FieldValue.arrayUnion([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
    await challengesReference.document(uid).updateData({
      'challenges': FieldValue.arrayRemove([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'description': description,
          'isCreator': false,
          'notes': notes,
          'title': title,
        }
      ])
    });
    if (isCreatorDone) {
      final DocumentSnapshot challengeNamesSnapshot =
          await challengeNamesReference.document(senderId).get();
      List justAccepted =
          List.from(challengeNamesSnapshot['$title Accepted Friends']);
      if (justAccepted.length == 0) {
        await challengeNamesReference.document(uid).updateData({
          'Names': FieldValue.arrayRemove([title]),
          '$title Invited Friends': FieldValue.delete(),
          '$title Accepted Friends': FieldValue.delete(),
          '$title Rejected Friends': FieldValue.delete(),
          '$title Completed Friends': FieldValue.delete(),
          '$title Canceled Friends': FieldValue.delete(),
          '$title Done by Creator': FieldValue.delete(),
        });
      }
    }
  }

  Future completeChallengeCreator(
    String senderId,
    String senderUserName,
    String senderFullName,
    String title,
    String description,
    String notes,
  ) async {
    final DocumentSnapshot challengeNamesSnapshot =
        await challengeNamesReference.document(senderId).get();
    List completedUsers =
        List.from(challengeNamesSnapshot['$title Completed Friends']);
    List noAnswer = List.from(challengeNamesSnapshot['$title Invited Friends']);
    List rejectedFriends =
        List.from(challengeNamesSnapshot['$title Rejected Friends']);
    List canceledFriends =
        List.from(challengeNamesSnapshot['$title Canceled Friends']);
    List justAccepted =
        List.from(challengeNamesSnapshot['$title Accepted Friends']);
    int acceptedListLength =
        challengeNamesSnapshot['$title Accepted Friends'].length;
    await challengesReference.document(uid).updateData({
      'challenges': FieldValue.arrayRemove([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'description': description,
          'isCreator': true,
          'notes': notes,
          'title': title,
        }
      ])
    });
    await memoriesReference
        .document(uid)
        .collection('categories')
        .document('Challenges')
        .updateData({
      'challenges': FieldValue.arrayUnion([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'description': description,
          'isCreator': true,
          'notes': notes,
          'title': title,
          'noAnswer Friends': noAnswer,
          'rejected': rejectedFriends,
          'completed': completedUsers + justAccepted,
          'canceled': canceledFriends,
        }
      ])
    });
    for (int i = 0; i < completedUsers.length; i++) {
      await memoriesReference
          .document(completedUsers[i]['uid'])
          .collection('categories')
          .document('Challenges')
          .updateData({
        'challenges': FieldValue.arrayUnion([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'description': description,
            'isCreator': false,
            'notes': notes,
            'title': title,
            'noAnswer Friends': noAnswer,
            'rejected': rejectedFriends,
            'completed': completedUsers + justAccepted,
            'canceled': canceledFriends,
          }
        ])
      });
    }
    for (int i = 0; i < noAnswer.length; i++) {
      await requestsReference.document(noAnswer[i]['uid']).updateData({
        'challenges': FieldValue.arrayRemove([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'description': description,
            'isCreator': false,
            'notes': notes,
            'title': title,
          }
        ]),
      });
    }
    if (acceptedListLength == 0) {
      await challengeNamesReference.document(uid).updateData({
        'Names': FieldValue.arrayRemove([title]),
        '$title Invited Friends': FieldValue.delete(),
        '$title Accepted Friends': FieldValue.delete(),
        '$title Rejected Friends': FieldValue.delete(),
        '$title Completed Friends': FieldValue.delete(),
        '$title Canceled Friends': FieldValue.delete(),
        '$title Done by Creator': FieldValue.delete(),
      });
    } else {
      await challengeNamesReference.document(uid).updateData({
        '$title Done by Creator': true,
      });
    }
  }

  Future cancelChallengeCreator(
    String senderId,
    String senderUserName,
    String senderFullName,
    String title,
    String description,
    String notes,
  ) async {
    final DocumentSnapshot challengeNamesSnapshot =
        await challengeNamesReference.document(senderId).get();
    List noAnswer = List.from(challengeNamesSnapshot['$title Invited Friends']);
    List justAccepted =
        List.from(challengeNamesSnapshot['$title Accepted Friends']);
    await challengesReference.document(uid).updateData({
      'challenges': FieldValue.arrayRemove([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'description': description,
          'isCreator': true,
          'notes': notes,
          'title': title,
        }
      ])
    });
    for (int i = 0; i < noAnswer.length; i++) {
      await requestsReference.document(noAnswer[i]['uid']).updateData({
        'challenges': FieldValue.arrayRemove([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'description': description,
            'isCreator': false,
            'notes': notes,
            'title': title,
          }
        ]),
      });
    }
    for (int i = 0; i < justAccepted.length; i++) {
      await challengesReference.document(justAccepted[i]['uid']).updateData({
        'challenges': FieldValue.arrayRemove([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'description': description,
            'isCreator': false,
            'notes': notes,
            'title': title,
          }
        ]),
      });
    }
    await challengeNamesReference.document(uid).updateData({
      'Names': FieldValue.arrayRemove([title]),
      '$title Invited Friends': FieldValue.delete(),
      '$title Accepted Friends': FieldValue.delete(),
      '$title Rejected Friends': FieldValue.delete(),
      '$title Completed Friends': FieldValue.delete(),
      '$title Canceled Friends': FieldValue.delete(),
      '$title Done by Creator': FieldValue.delete(),
    });
  }

  Future checkCreatorComplete(
    bool isCreator,
    senderId,
    senderUserName,
    senderFullName,
    title,
    description,
    notes,
  ) async {
    return isCreator
        ? await CRDatabaseServices(uid: uid).completeChallengeCreator(
            senderId,
            senderUserName,
            senderFullName,
            title,
            description,
            notes,
          )
        : await CRDatabaseServices(uid: uid).completeChallengeReceiver(
            senderId,
            senderUserName,
            senderFullName,
            title,
            description,
            notes,
          );
  }

  Future checkCreatorCancelChallenge(bool isCreator, senderId, senderUserName,
      senderFullName, title, description, notes) async {
    return isCreator
        ? await CRDatabaseServices(uid: uid).cancelChallengeCreator(
            senderId,
            senderUserName,
            senderFullName,
            title,
            description,
            notes,
          )
        : await CRDatabaseServices(uid: uid).cancelChallengeReceiver(
            senderId,
            senderUserName,
            senderFullName,
            title,
            description,
            notes,
          );
  }

  Future getAcceptedUsersChallenges(
    String title,
  ) async {
    final CollectionReference challengeNamesReference =
        Firestore.instance.collection('challengeNames');
    final DocumentSnapshot challengeNamesSnapshot =
        await challengeNamesReference.document(uid).get();
    return List.from(challengeNamesSnapshot['$title Accepted Friends']);
  }
}
