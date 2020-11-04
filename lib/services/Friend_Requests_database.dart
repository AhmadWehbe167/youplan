import 'package:cloud_firestore/cloud_firestore.dart';

class FRDatabaseService {
  String userName = 'userName';
  String fullName = 'fullName';
  final String uid;

  FRDatabaseService({
    this.uid,
  });

  final CollectionReference usersReference =
      FirebaseFirestore.instance.collection('User');
  final CollectionReference friendsReference =
      FirebaseFirestore.instance.collection('Friends');
  final CollectionReference plansReference =
      FirebaseFirestore.instance.collection('Plans');
  final CollectionReference memoriesReference =
      FirebaseFirestore.instance.collection('Memories');
  final CollectionReference requestsReference =
      FirebaseFirestore.instance.collection('Requests');
  final CollectionReference userNamesReference =
      FirebaseFirestore.instance.collection('userNames');
  final CollectionReference planNamesReference =
      FirebaseFirestore.instance.collection('planNames');

  bool checkUserInList(List users, String userId) {
    for (int i = 0; i < users.length; i++) {
      if (users[i]['uid'] == userId) {
        return true;
      }
    }
    return false;
  }

  Future<bool> userIsFriend(String receiverId) async {
    final DocumentSnapshot friendsSnapshot =
        await friendsReference.doc(uid).get();
    List friends = await friendsSnapshot.data()['friends'] ?? [];
    return (checkUserInList(friends, receiverId));
  }

  Future<bool> userSentMeRequest(String receiverId) async {
    final DocumentSnapshot myRequestSnapshot =
        await requestsReference.doc(uid).get();
    List myRequests = await myRequestSnapshot.data()['friends'] ?? [];
    return (checkUserInList(myRequests, receiverId));
  }

  Future<bool> userSentRequestByMe(String receiverId) async {
    final DocumentSnapshot requestSnapshot =
        await requestsReference.doc(receiverId).get();
    List requests = await requestSnapshot.data()['friends'] ?? [];
    return (checkUserInList(requests, uid));
  }

  Future sendFriendRequest(String receiverId) async {
    final DocumentSnapshot userSnapshot = await usersReference.doc(uid).get();
    String myUserName = await userSnapshot.data()['$userName'] ?? '';
    String myFullName = await userSnapshot.data()['$fullName'] ?? '';
    return await requestsReference.doc(receiverId).update({
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
    final DocumentSnapshot doc = await usersReference.doc(uid).get();
    final DocumentSnapshot doc2 = await usersReference.doc(senderId).get();
    String myUserName = await doc.data()['$userName'];
    String otherUserName = await doc2.data()['$userName'];
    String myFullName = await doc.data()['$fullName'];
    String otherFullName = await doc2.data()['$fullName'];

    await friendsReference.doc(uid).update({
      'friends': FieldValue.arrayUnion([
        {
          'uid': senderId,
          '$userName': otherUserName,
          '$fullName': otherFullName,
        }
      ])
    });
    await friendsReference.doc(senderId).update({
      'friends': FieldValue.arrayUnion([
        {
          'uid': uid,
          '$userName': myUserName,
          '$fullName': myFullName,
        }
      ])
    });
    return await requestsReference.doc(uid).update({
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
    final DocumentSnapshot doc = await usersReference.doc(senderId).get();
    String otherUserName = await doc.data()['$userName'];
    String otherFullName = await doc.data()['$fullName'];
    return await requestsReference.doc(uid).update({
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
    final DocumentSnapshot userSnapshot = await usersReference.doc(uid).get();
    String myUserName = await userSnapshot.data()['$userName'] ?? '';
    String myFullName = await userSnapshot.data()['$fullName'] ?? '';
    return await requestsReference.doc(receiverId).update({
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
    final DocumentSnapshot myDoc = await usersReference.doc(uid).get();
    final DocumentSnapshot otherDoc =
        await usersReference.doc(receiverId).get();
    String myUserName = await myDoc.data()['$userName'] ?? '';
    String myFullName = await myDoc.data()['$fullName'] ?? '';
    String otherUserName = await otherDoc.data()['$userName'] ?? '';
    String otherFullName = await otherDoc.data()['$fullName'] ?? '';
    await friendsReference.doc(receiverId).update({
      'friends': FieldValue.arrayRemove([
        {
          'uid': uid,
          '$userName': myUserName,
          '$fullName': myFullName,
        }
      ])
    });
    return await friendsReference.doc(uid).update({
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
