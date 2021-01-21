import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserData {
  String uid;
  String userName;
  String fullName;
  String bio;
  String profileImage;
  int plansCount;

  UserData(AsyncSnapshot snapshot) {
    var userDoc = snapshot.data;
    this.userName = userDoc['userName'];
    this.fullName = userDoc['fullName'];
    this.bio = userDoc['bio'];
    this.plansCount = userDoc['plans count'];
    this.plansCount = userDoc['plans count'];
    this.profileImage = userDoc['profile image'];
  }
}
