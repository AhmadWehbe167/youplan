import 'package:youplan/Model/Users_Data.dart';

userExists(String uid, List users) {
  for (int i = 0; i < users.length; i++) {
    if (users[i]['uid'] == uid) {
      return true;
    }
  }
  return false;
}

userDataExists(UserData user, List<UserData> users) {
  for (int i = 0; i < users.length; i++) {
    if (users[i].uid == user.uid) {
      return true;
    }
  }
  return false;
}
