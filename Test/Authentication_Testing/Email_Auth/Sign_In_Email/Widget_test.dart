import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as test;
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:test/test.dart';
import 'package:youplan/Authenticate_Screens/Email_Auth/Sign_in_Page.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/services/auth.dart';

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

class AuthServicesMock extends Mock implements AuthServices {
  final FirebaseAuthMock firebaseAuthMock;
  AuthServicesMock({this.firebaseAuthMock});
}

class UserMock extends Mock implements User {}

void main() async {
  String randomUid;
  FirebaseAuthMock firebaseAuthMock;
  AuthServicesMock authServices;
  var emailField = test.find.byType(TextField).first;
  var passwordField = test.find.byType(TextField).last;
  var signInButton = test.find.text('Log In');

  setUpAll(() {
    randomUid = "jalkdjkajdkajkdljakjdklajlkd";
    firebaseAuthMock = FirebaseAuthMock();
    authServices = AuthServicesMock(
      firebaseAuthMock: firebaseAuthMock,
    );
    Stream<Muser> mUserStream() async* {
      while (true) {
        yield Muser(
          uid: randomUid,
          isEmailVerified: false,
        );
      }
    }

    when(authServices.userStream).thenAnswer((_) {
      return mUserStream();
    });
  });

  Widget makeTestable(Widget child) {
    return StreamProvider<Muser>.value(
      value: authServices.userStream,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: child,
      ),
    );
  }

  Future<void> buildWidget(test.WidgetTester tester) async {
    await tester.pumpWidget(makeTestable(
      SignInPage(
        auth: authServices,
        height: 683.4285714285714,
        width: 411.42857142857144,
      ),
    ));
  }

  group("Testing Log In functionality", () {
    String mandatoryMsg = "This is mandatory";
    String invalidMsg = "Please Provide a valid email";
    String invalidPassMsg = 'Password should be at least 6 characters';
    String invalidPassMsg2 = "Password should not be more than 27";

    test.testWidgets(
        "Check response when user email is empty and login button is clicked",
        (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.tap(passwordField);
        await tester.enterText(passwordField, "ahmad12345");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(mandatoryMsg), test.findsOneWidget);
      });
    });

    test.testWidgets(
        "Check response when password is empty and login button is clicked",
        (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.tap(emailField);
        await tester.enterText(emailField, "ahmad@mail.com");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(mandatoryMsg), test.findsOneWidget);
      });
    });

    test.testWidgets(
        "Check response when email is invalid and login button is clicked",
        (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.tap(emailField);
        await tester.enterText(emailField, "ahmadcom");
        await tester.tap(passwordField);
        await tester.enterText(passwordField, "ahmad12345");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(invalidMsg), test.findsOneWidget);
      });
    });

    test.testWidgets(
        "Check response when password is short and login button is clicked",
        (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.tap(emailField);
        await tester.enterText(emailField, "ahmad@gmail.com");
        await tester.tap(passwordField);
        await tester.enterText(passwordField, "ahm");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(invalidPassMsg), test.findsOneWidget);
      });
    });

    test.testWidgets(
        "Check response when password is long and login button is clicked",
        (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.tap(emailField);
        await tester.enterText(emailField, "ahmad@gmail.com");
        await tester.tap(passwordField);
        await tester.enterText(passwordField, "123456789 123456789 123456789");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(invalidPassMsg2), test.findsOneWidget);
      });
    });
  });
}
