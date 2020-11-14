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

String errorMessagesHandler(dynamic error) {
  if (error.code == "user-not-found") {
    return "There is no user with this email. Make sure your email is correct or register for an account if you have not yet.";
  } else if (error.code == "wrong-password") {
    return "Password is wrong!";
  } else {
    return "Something went wrong please try again.";
  }
}
