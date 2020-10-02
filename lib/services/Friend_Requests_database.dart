import 'package:cloud_firestore/cloud_firestore.dart';

class FRDatabaseService {
  String userName = 'userName';
  String fullName = 'fullName';
  final String uid;

  FRDatabaseService({
    this.uid,
  });

  final CollectionReference usersReference =
      Firestore.instance.collection('User');
  final CollectionReference friendsReference =
      Firestore.instance.collection('Friends');
  final CollectionReference plansReference =
      Firestore.instance.collection('Plans');
  final CollectionReference challengesReference =
      Firestore.instance.collection('Challenges');
  final CollectionReference memoriesReference =
      Firestore.instance.collection('Memories');
  final CollectionReference requestsReference =
      Firestore.instance.collection('Requests');
  final CollectionReference userNamesReference =
      Firestore.instance.collection('userNames');
  final CollectionReference planNamesReference =
      Firestore.instance.collection('planNames');
  final CollectionReference challengeNamesReference =
      Firestore.instance.collection('challengeNames');

  bool checkUserInList(List users, String userId) {
    for (int i = 0; i < users.length; i++) {
      if (users[i]['uid'] == userId) {
        return true;
      }
    }
    return false;
  }

  Future initUser(String userNameArg, String fullNameArg) async {
    await usersReference.document(uid).setData({
      '$userName': userNameArg,
      '$fullName': fullNameArg,
    });
    await friendsReference.document(uid).setData({
      'friends': [],
    });
    await plansReference.document(uid).setData({
      'plans': [],
    });
    await challengesReference.document(uid).setData({
      'challenges': [],
    });
    await memoriesReference
        .document(uid)
        .collection('categories')
        .document('Food & Drink')
        .setData({
      'plans': [],
    });
    await memoriesReference
        .document(uid)
        .collection('categories')
        .document('Concerts & Shows')
        .setData({
      'plans': [],
    });
    await memoriesReference
        .document(uid)
        .collection('categories')
        .document('Entertainment')
        .setData({
      'plans': [],
    });
    await memoriesReference
        .document(uid)
        .collection('categories')
        .document('Cultural & Arts')
        .setData({
      'plans': [],
    });
    await memoriesReference
        .document(uid)
        .collection('categories')
        .document('Other')
        .setData({
      'plans': [],
    });
    await memoriesReference
        .document(uid)
        .collection('categories')
        .document('Challenges')
        .setData({
      'challenges': [],
    });
    await planNamesReference.document(uid).setData({
      'Names': [],
    });
    await challengeNamesReference.document(uid).setData({
      'Names': [],
    });
    await userNamesReference.document(userNameArg.toUpperCase()).setData({});
    return await requestsReference.document(uid).setData({
      'friends': [],
      'plans': [],
      'challenges': [],
    });
  }

  Future<bool> userIsFriend(String receiverId) async {
    final DocumentSnapshot friendsSnapshot =
        await friendsReference.document(uid).get();
    List friends = await friendsSnapshot.data['friends'] ?? [];
    return (checkUserInList(friends, receiverId));
  }

  Future<bool> userSentMeRequest(String receiverId) async {
    final DocumentSnapshot myRequestSnapshot =
        await requestsReference.document(uid).get();
    List myRequests = await myRequestSnapshot.data['friends'] ?? [];
    return (checkUserInList(myRequests, receiverId));
  }

  Future<bool> userSentRequestByMe(String receiverId) async {
    final DocumentSnapshot requestSnapshot =
        await requestsReference.document(receiverId).get();
    List requests = await requestSnapshot.data['friends'] ?? [];
    return (checkUserInList(requests, uid));
  }

  Future sendFriendRequest(String receiverId) async {
    final DocumentSnapshot userSnapshot =
        await usersReference.document(uid).get();
    String myUserName = await userSnapshot.data['$userName'] ?? '';
    String myFullName = await userSnapshot.data['$fullName'] ?? '';
    return await requestsReference.document(receiverId).updateData({
      'friends': FieldValue.arrayUnion([
        {
          'uid': uid,
          '$userName': myUserName,
          '$fullName': myFullName,
        }
      ]),
    });
  }

  Future acceptFriendRequest(String senderId) async {
    final DocumentSnapshot doc = await usersReference.document(uid).get();
    final DocumentSnapshot doc2 = await usersReference.document(senderId).get();
    String myUserName = await doc.data['$userName'];
    String otherUserName = await doc2.data['$userName'];
    String myFullName = await doc.data['$fullName'];
    String otherFullName = await doc2.data['$fullName'];

    await friendsReference.document(uid).updateData({
      'friends': FieldValue.arrayUnion([
        {
          'uid': senderId,
          '$userName': otherUserName,
          '$fullName': otherFullName,
        }
      ])
    });
    await friendsReference.document(senderId).updateData({
      'friends': FieldValue.arrayUnion([
        {
          'uid': uid,
          '$userName': myUserName,
          '$fullName': myFullName,
        }
      ])
    });
    return await requestsReference.document(uid).updateData({
      'friends': FieldValue.arrayRemove([
        {
          'uid': senderId,
          '$userName': otherUserName,
          '$fullName': otherFullName,
        }
      ])
    });
  }

  Future rejectFriendRequest(String senderId) async {
    final DocumentSnapshot doc = await usersReference.document(senderId).get();
    String otherUserName = await doc.data['$userName'];
    String otherFullName = await doc.data['$fullName'];
    return await requestsReference.document(uid).updateData({
      'friends': FieldValue.arrayRemove([
        {
          'uid': senderId,
          '$userName': otherUserName,
          '$fullName': otherFullName,
        }
      ])
    });
  }

  Future cancelFriendRequest(String receiverId) async {
    final DocumentSnapshot userSnapshot =
        await usersReference.document(uid).get();
    String myUserName = await userSnapshot.data['$userName'] ?? '';
    String myFullName = await userSnapshot.data['$fullName'] ?? '';
    return await requestsReference.document(receiverId).updateData({
      'friends': FieldValue.arrayRemove([
        {
          'uid': uid,
          '$userName': myUserName,
          '$fullName': myFullName,
        }
      ])
    });
  }

  Future unFriendUser(String receiverId) async {
    final DocumentSnapshot myDoc = await usersReference.document(uid).get();
    final DocumentSnapshot otherDoc =
        await usersReference.document(receiverId).get();
    String myUserName = await myDoc.data['$userName'] ?? '';
    String myFullName = await myDoc.data['$fullName'] ?? '';
    String otherUserName = await otherDoc.data['$userName'] ?? '';
    String otherFullName = await otherDoc.data['$fullName'] ?? '';
    await friendsReference.document(receiverId).updateData({
      'friends': FieldValue.arrayRemove([
        {
          'uid': uid,
          '$userName': myUserName,
          '$fullName': myFullName,
        }
      ])
    });
    return await friendsReference.document(uid).updateData({
      'friends': FieldValue.arrayRemove([
        {
          'uid': receiverId,
          '$userName': otherUserName,
          '$fullName': otherFullName,
        }
      ])
    });
  }
}
