import 'package:cloud_firestore/cloud_firestore.dart';

import 'collections_references.dart';

class PRDatabaseServices {
  final String uid;

  PRDatabaseServices({
    this.uid,
  });

  Future checkPlanAvailable(
    String title,
  ) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('planNames').doc(uid).get();
    return List.from(doc.data()['Names']);
  }

  Future setPlanInfo(String title, List friendsInvited) async {
    await planNamesReference.doc(uid).update({
      'Names': FieldValue.arrayUnion([title]),
      '$title Invited Friends': friendsInvited,
      '$title Accepted Friends': [],
      '$title Rejected Friends': [],
      '$title Completed Friends': [],
      '$title Canceled Friends': [],
      '$title Done by Creator': false,
    });
  }

  Future sendPlanRequest(
    String receiverId,
    String title,
    String type,
    DateTime date,
    String place,
    String description,
    String notes,
    bool isCreator, {
    List<Map<String, String>> friendsInvited,
    List<Map<String, String>> friendsAccepted,
  }) async {
    final DocumentSnapshot userSnapshot = await usersReference.doc(uid).get();
    String myUserName = await userSnapshot.data()['userName'];
    String myFullName = await userSnapshot.data()['fullName'];
    return await requestsReference.doc(receiverId).update({
      'plans': FieldValue.arrayUnion([
        {
          'creator uid': uid,
          'creator userName': myUserName,
          'creator fullName': myFullName,
          'title': title,
          'type': type,
          'date': date,
          'place': place,
          'description': description,
          'notes': notes,
          'isCreator': isCreator,
        }
      ]),
    });
  }

  Future rejectPlanRequest(
    String senderId,
    String senderUserName,
    String senderFullName,
    String title,
    Timestamp date,
    String place,
    String type,
    String description,
    String notes,
    bool isCreator,
  ) async {
    final DocumentSnapshot userSnapshot = await usersReference.doc(uid).get();
    final DocumentSnapshot planInfoSnapshot =
        await planNamesReference.doc(senderId).get();
    String myUserName = await userSnapshot.data()['userName'];
    String myFullName = await userSnapshot.data()['fullName'];
    await requestsReference.doc(uid).update({
      'plans': FieldValue.arrayRemove([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'date': date,
          'description': description,
          'isCreator': isCreator,
          'notes': notes,
          'place': place,
          'title': title,
          'type': type,
        }
      ])
    });
    await planNamesReference.doc(senderId).update({
      '$title Invited Friends': FieldValue.arrayRemove([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
    await planNamesReference.doc(senderId).update({
      '$title Rejected Friends': FieldValue.arrayUnion([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
    if (planInfoSnapshot.data()['$title Invited Friends'].length == 0) {
      await requestsReference.doc(senderId).update({
        'plans': FieldValue.arrayRemove([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'date': date,
            'description': description,
            'isCreator': true,
            'notes': notes,
            'place': place,
            'title': title,
            'type': type,
          }
        ])
      });
    }
  }

  Future acceptPlanRequest(
    String senderId,
    String senderUserName,
    String senderFullName,
    String title,
    Timestamp date,
    String place,
    String type,
    String description,
    String notes,
    bool isCreator,
  ) async {
    final DocumentSnapshot planInfoSnapshot =
        await planNamesReference.doc(senderId).get();
    await requestsReference.doc(uid).update({
      'plans': FieldValue.arrayRemove([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'date': date,
          'description': description,
          'isCreator': isCreator,
          'notes': notes,
          'place': place,
          'title': title,
          'type': type,
        }
      ])
    });
    await plansReference.doc(uid).update({
      'plans': FieldValue.arrayUnion([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'date': date,
          'description': description,
          'isCreator': isCreator,
          'notes': notes,
          'place': place,
          'title': title,
          'type': type,
        }
      ])
    });
    if (planInfoSnapshot.data()['$title Accepted Friends'].length == 0) {
      await requestsReference.doc(senderId).update({
        'plans': FieldValue.arrayRemove([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'date': date,
            'description': description,
            'isCreator': true,
            'notes': notes,
            'place': place,
            'title': title,
            'type': type,
          }
        ])
      });
      await plansReference.doc(senderId).update({
        'plans': FieldValue.arrayUnion([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'date': date,
            'description': description,
            'isCreator': true,
            'notes': notes,
            'place': place,
            'title': title,
            'type': type,
          }
        ])
      });
    }
    final DocumentSnapshot userSnapshot = await usersReference.doc(uid).get();
    String myUserName = await userSnapshot.data()['userName'];
    String myFullName = await userSnapshot.data()['fullName'];
    await planNamesReference.doc(senderId).update({
      '$title Invited Friends': FieldValue.arrayRemove([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
    await planNamesReference.doc(senderId).update({
      '$title Accepted Friends': FieldValue.arrayUnion([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
  }

  Future completePlanReceiver(
    String senderId,
    String senderUserName,
    String senderFullName,
    String title,
    Timestamp date,
    String place,
    String type,
    String description,
    String notes,
  ) async {
    final DocumentSnapshot userSnapshot = await usersReference.doc(uid).get();
    final DocumentSnapshot planNamesSnapshot =
        await planNamesReference.doc(senderId).get();
    String myUserName = await userSnapshot.data()['userName'];
    String myFullName = await userSnapshot.data()['fullName'];
    bool isCreatorDone =
        await planNamesSnapshot.data()['$title Done by Creator'];
    await planNamesReference.doc(senderId).update({
      '$title Accepted Friends': FieldValue.arrayRemove([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
    await planNamesReference.doc(senderId).update({
      '$title Completed Friends': FieldValue.arrayUnion([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
    await plansReference.doc(uid).update({
      'plans': FieldValue.arrayRemove([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'date': date,
          'description': description,
          'isCreator': false,
          'notes': notes,
          'place': place,
          'title': title,
          'type': type,
        }
      ])
    });
    if (isCreatorDone) {
      final DocumentSnapshot planNamesSnapshot =
          await planNamesReference.doc(senderId).get();
      List completedUsers =
          List.from(planNamesSnapshot['$title Completed Friends']);
      List noAnswer = List.from(planNamesSnapshot['$title Invited Friends']);
      List rejectedFriends =
          List.from(planNamesSnapshot['$title Rejected Friends']);
      List canceledFriends =
          List.from(planNamesSnapshot['$title Canceled Friends']);
      List justAccepted =
          List.from(planNamesSnapshot['$title Accepted Friends']);
      await memoriesReference
          .doc(uid)
          .collection('categories')
          .doc(type)
          .update({
        'plans': FieldValue.arrayUnion([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'date': date,
            'description': description,
            'isCreator': false,
            'notes': notes,
            'place': place,
            'title': title,
            'type': type,
            'noAnswer Friends': noAnswer,
            'rejected': rejectedFriends,
            'completed': completedUsers + justAccepted,
            'canceled': canceledFriends,
          }
        ])
      });
      if (justAccepted.length == 0) {
        await planNamesReference.doc(uid).update({
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

  Future cancelPlanReceiver(
    String senderId,
    String senderUserName,
    String senderFullName,
    String title,
    Timestamp date,
    String place,
    String type,
    String description,
    String notes,
  ) async {
    final DocumentSnapshot userSnapshot = await usersReference.doc(uid).get();
    final DocumentSnapshot planNamesSnapshot =
        await planNamesReference.doc(senderId).get();
    String myUserName = await userSnapshot.data()['userName'];
    String myFullName = await userSnapshot.data()['fullName'];
    bool isCreatorDone =
        await planNamesSnapshot.data()['$title Done by Creator'];
    await planNamesReference.doc(senderId).update({
      '$title Accepted Friends': FieldValue.arrayRemove([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
    await planNamesReference.doc(senderId).update({
      '$title Canceled Friends': FieldValue.arrayUnion([
        {
          'fullName': myFullName,
          'uid': uid,
          'userName': myUserName,
        }
      ]),
    });
    await plansReference.doc(uid).update({
      'plans': FieldValue.arrayRemove([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'date': date,
          'description': description,
          'isCreator': false,
          'notes': notes,
          'place': place,
          'title': title,
          'type': type,
        }
      ])
    });
    if (isCreatorDone) {
      final DocumentSnapshot planNamesSnapshot =
          await planNamesReference.doc(senderId).get();
      List justAccepted =
          List.from(planNamesSnapshot['$title Accepted Friends']);
      if (justAccepted.length == 0) {
        await planNamesReference.doc(uid).update({
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

  Future completePlanCreator(
    String senderId,
    String senderUserName,
    String senderFullName,
    String title,
    Timestamp date,
    String place,
    String type,
    String description,
    String notes,
    List ignoredUsers,
  ) async {
    final DocumentSnapshot planNamesSnapshot =
        await planNamesReference.doc(senderId).get();
    List completedUsers =
        List.from(planNamesSnapshot['$title Completed Friends']);
    List noAnswer = List.from(planNamesSnapshot['$title Invited Friends']);
    List rejectedFriends =
        List.from(planNamesSnapshot['$title Rejected Friends']);
    List canceledFriends =
        List.from(planNamesSnapshot['$title Canceled Friends']);
    List justAccepted = List.from(planNamesSnapshot['$title Accepted Friends']);
    justAccepted.removeWhere((element) => ignoredUsers.contains(element));
    await plansReference.doc(uid).update({
      'plans': FieldValue.arrayRemove([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'date': date,
          'description': description,
          'isCreator': true,
          'notes': notes,
          'place': place,
          'title': title,
          'type': type,
        }
      ])
    });
    await memoriesReference.doc(uid).collection('categories').doc(type).update({
      'plans': FieldValue.arrayUnion([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'date': date,
          'description': description,
          'isCreator': true,
          'notes': notes,
          'place': place,
          'title': title,
          'type': type,
          'noAnswer Friends': noAnswer,
          'rejected': rejectedFriends,
          'completed': completedUsers + justAccepted,
          'canceled': canceledFriends,
        }
      ])
    });
    for (int i = 0; i < completedUsers.length; i++) {
      await memoriesReference
          .doc(completedUsers[i]['uid'])
          .collection('categories')
          .doc(type)
          .update({
        'plans': FieldValue.arrayUnion([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'date': date,
            'description': description,
            'isCreator': false,
            'notes': notes,
            'place': place,
            'title': title,
            'type': type,
            'noAnswer Friends': noAnswer,
            'rejected': rejectedFriends,
            'completed': completedUsers + justAccepted,
            'canceled': canceledFriends,
          }
        ])
      });
    }
    for (int i = 0; i < noAnswer.length; i++) {
      await requestsReference.doc(noAnswer[i]['uid']).update({
        'plans': FieldValue.arrayRemove([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'date': date,
            'description': description,
            'isCreator': false,
            'notes': notes,
            'place': place,
            'title': title,
            'type': type,
          }
        ]),
      });
    }
    for (int i = 0; i < ignoredUsers.length; i++) {
      await plansReference.doc(ignoredUsers[i]['uid']).update({
        'plans': FieldValue.arrayRemove([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'date': date,
            'description': description,
            'isCreator': false,
            'notes': notes,
            'place': place,
            'title': title,
            'type': type,
          }
        ]),
      });
    }
    if (planNamesSnapshot['$title Accepted Friends'].length == 0) {
      await planNamesReference.doc(uid).update({
        'Names': FieldValue.arrayRemove([title]),
        '$title Invited Friends': FieldValue.delete(),
        '$title Accepted Friends': FieldValue.delete(),
        '$title Rejected Friends': FieldValue.delete(),
        '$title Completed Friends': FieldValue.delete(),
        '$title Canceled Friends': FieldValue.delete(),
        '$title Done by Creator': FieldValue.delete(),
      });
    } else {
      await planNamesReference.doc(uid).update({
        '$title Done by Creator': true,
      });
      for (int i = 0; i < ignoredUsers.length; i++) {
        await planNamesReference.doc(uid).update({
          '$title Accepted Friends': FieldValue.arrayRemove([
            ignoredUsers[i],
          ]),
        });
        await planNamesReference.doc(uid).update({
          '$title Canceled Friends': FieldValue.arrayUnion([
            ignoredUsers[i],
          ]),
        });
      }
    }
  }

  Future cancelPlanCreator(
    String senderId,
    String senderUserName,
    String senderFullName,
    String title,
    Timestamp date,
    String place,
    String type,
    String description,
    String notes,
  ) async {
    final DocumentSnapshot planNamesSnapshot =
        await planNamesReference.doc(senderId).get();
    List noAnswer = List.from(planNamesSnapshot['$title Invited Friends']);
    List justAccepted = List.from(planNamesSnapshot['$title Accepted Friends']);
    await plansReference.doc(uid).update({
      'plans': FieldValue.arrayRemove([
        {
          'creator fullName': senderFullName,
          'creator uid': senderId,
          'creator userName': senderUserName,
          'date': date,
          'description': description,
          'isCreator': true,
          'notes': notes,
          'place': place,
          'title': title,
          'type': type,
        }
      ])
    });
    for (int i = 0; i < noAnswer.length; i++) {
      await requestsReference.doc(noAnswer[i]['uid']).update({
        'plans': FieldValue.arrayRemove([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'date': date,
            'description': description,
            'isCreator': false,
            'notes': notes,
            'place': place,
            'title': title,
            'type': type,
          }
        ]),
      });
    }
    for (int i = 0; i < justAccepted.length; i++) {
      await plansReference.doc(justAccepted[i]['uid']).update({
        'plans': FieldValue.arrayRemove([
          {
            'creator fullName': senderFullName,
            'creator uid': senderId,
            'creator userName': senderUserName,
            'date': date,
            'description': description,
            'isCreator': false,
            'notes': notes,
            'place': place,
            'title': title,
            'type': type,
          }
        ]),
      });
    }
    await planNamesReference.doc(uid).update({
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
    date,
    place,
    type,
    description,
    notes,
    ignoredUsers,
  ) async {
    return isCreator
        ? await PRDatabaseServices(uid: uid).completePlanCreator(
            senderId,
            senderUserName,
            senderFullName,
            title,
            date,
            place,
            type,
            description,
            notes,
            ignoredUsers,
          )
        : await PRDatabaseServices(uid: uid).completePlanReceiver(
            senderId,
            senderUserName,
            senderFullName,
            title,
            date,
            place,
            type,
            description,
            notes);
  }

  Future checkCreatorCancel(bool isCreator, senderId, senderUserName,
      senderFullName, title, date, place, type, description, notes) async {
    return isCreator
        ? await PRDatabaseServices(uid: uid).cancelPlanCreator(
            senderId,
            senderUserName,
            senderFullName,
            title,
            date,
            place,
            type,
            description,
            notes)
        : await PRDatabaseServices(uid: uid).cancelPlanReceiver(
            senderId,
            senderUserName,
            senderFullName,
            title,
            date,
            place,
            type,
            description,
            notes);
  }

  Future getAcceptedUsers(
    String title,
  ) async {
    final CollectionReference planNamesReference =
        FirebaseFirestore.instance.collection('planNames');
    final DocumentSnapshot planNamesSnapshot =
        await planNamesReference.doc(uid).get();
    return List.from(planNamesSnapshot['$title Accepted Friends']);
  }
}
