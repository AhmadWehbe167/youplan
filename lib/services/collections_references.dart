import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference requestsReference =
    Firestore.instance.collection('Requests');
final CollectionReference challengesReference =
    Firestore.instance.collection('Challenges');
final CollectionReference plansReference =
    Firestore.instance.collection('Plans');
final CollectionReference userNamesReference =
    Firestore.instance.collection('userNames');
final CollectionReference planNamesReference =
    Firestore.instance.collection('planNames');
final CollectionReference challengeNamesReference =
    Firestore.instance.collection('challengeNames');
final CollectionReference memoriesReference =
    Firestore.instance.collection('Memories');
final CollectionReference usersReference =
    Firestore.instance.collection('User');
