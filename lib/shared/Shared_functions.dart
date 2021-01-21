import 'package:youplan/Model/User_Data.dart';

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
  print("Error code is ${error.code} and message is ${error.message}");
  if (error.code == "user-not-found") {
    return "There is no user with this email. Make sure your email is correct or register for an account if you have not yet.";
  } else if (error.code == "wrong-password") {
    return "Password is wrong";
  } else if (error.code == "phone-number-already-exists") {
    return "Phone number is already in use by another account";
  } else if (error.code == "email-already-in-use") {
    return "This Email is already in use by another account";
  } else {
    return "Something went wrong please try again.";
  }
}
