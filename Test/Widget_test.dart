import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:youplan/services/auth.dart';

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

void main() async {
  group("Testing Sign In", () {
    final FirebaseAuthMock firebaseAuthMock = FirebaseAuthMock();
    final AuthServices authServices = AuthServices(
      auth: firebaseAuthMock,
    );

    test("Sign in with email and password", () {});
  });
}
