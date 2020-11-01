import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference requestsReference =
    FirebaseFirestore.instance.collection('Requests');
final CollectionReference plansReference =
    FirebaseFirestore.instance.collection('Plans');
final CollectionReference userNamesReference =
    FirebaseFirestore.instance.collection('userNames');
final CollectionReference planNamesReference =
    FirebaseFirestore.instance.collection('planNames');
final CollectionReference memoriesReference =
    FirebaseFirestore.instance.collection('Memories');
final CollectionReference usersReference =
    FirebaseFirestore.instance.collection('User');
