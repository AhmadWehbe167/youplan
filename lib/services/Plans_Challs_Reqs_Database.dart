import 'package:cloud_firestore/cloud_firestore.dart';

class PCRDatabaseServices {
  final String uid;
  PCRDatabaseServices({this.uid});

  final CollectionReference usersReference =
      Firestore.instance.collection('User');
  final CollectionReference friendsReference =
      Firestore.instance.collection('Friends');
  final CollectionReference plansReference =
      Firestore.instance.collection('Plans');
  final CollectionReference requestsReference =
      Firestore.instance.collection('Requests');
  final CollectionReference userNamesReference =
      Firestore.instance.collection('userNames');
}
