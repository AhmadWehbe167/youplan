import 'package:cloud_firestore/cloud_firestore.dart';

class PCRDatabaseServices {
  final String uid;
  PCRDatabaseServices({this.uid});

  final CollectionReference usersReference =
      FirebaseFirestore.instance.collection('User');
  final CollectionReference friendsReference =
      FirebaseFirestore.instance.collection('Friends');
  final CollectionReference plansReference =
      FirebaseFirestore.instance.collection('Plans');
  final CollectionReference requestsReference =
      FirebaseFirestore.instance.collection('Requests');
  final CollectionReference userNamesReference =
      FirebaseFirestore.instance.collection('userNames');
}
