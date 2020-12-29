import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as test;
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:test/test.dart';
import 'package:youplan/Authenticate_Screens/Email_Auth/SignUp_Page.dart';
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
  var userName = test.find.byType(TextField).first;
  var fullName = test.find.widgetWithText(TextField, "Full Name");
  var email = test.find.widgetWithText(TextField, "Email");
  var password = test.find.widgetWithText(TextField, "Password");
  // var confirmPassword = test.find.byType(TextField).last;
  var signInButton = test.find.text('Sign Up');

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
    await tester.pumpWidget(makeTestable(SignUpPage(
      auth: authServices,
      height: 683.4285714285714,
      width: 411.42857142857144,
    )));
  }

  group("UserName Testing", () {
    String shortUserName = 'UserName should be at least 3 characters';
    String longUserName = 'UserName should not be more than 27';
    String noWhiteSpaces = 'White spaces not allowed';
    String onlyCharNb = 'only characters & numbers';

    test.testWidgets("UserName short", (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.enterText(userName, "as");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(shortUserName), test.findsOneWidget);
      });
    });

    test.testWidgets("UserName long", (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.enterText(userName, "ahmadahmadahmadahmadahmadahmad");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(longUserName), test.findsOneWidget);
      });
    });

    test.testWidgets("White spaces in UserName",
        (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.enterText(userName, "Ahmad Wehbe");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(noWhiteSpaces), test.findsOneWidget);
      });
    });

    test.testWidgets("symbols in userName", (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.enterText(userName, "Ahmad\$#");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(onlyCharNb), test.findsOneWidget);
      });
    });
  });
  group("FullName Testing", () {
    String shortFullName = 'Name should be at least 4 characters';
    String longFullName = 'Name should not be more than 27';
    String symbols = 'use only characters';

    test.testWidgets("short fullName", (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.enterText(fullName, "ahm");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(shortFullName), test.findsOneWidget);
      });
    });

    test.testWidgets("long fullName", (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.enterText(fullName, "ahmadwehbeahmadwehbeahmadweh");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(longFullName), test.findsOneWidget);
      });
    });

    test.testWidgets("symbols in fullName", (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.enterText(fullName, "ahmad#wehbe");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(symbols), test.findsOneWidget);
      });
    });
  });
  group("Email Testing", () {
    String invalidEmail = 'Please Provide a valid email';

    test.testWidgets("just userName", (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.enterText(email, "ahmad");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(invalidEmail), test.findsOneWidget);
      });
    });
    test.testWidgets("invalid hostName", (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.enterText(email, "ahmad@!.com");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(invalidEmail), test.findsOneWidget);
      });
    });
    test.testWidgets("invalid top Level domain",
        (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.enterText(email, "ahmad@gmail.co#");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(invalidEmail), test.findsOneWidget);
      });
    });
    test.testWidgets("invalid @", (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.enterText(email, "ahmad#gmail.com");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(invalidEmail), test.findsOneWidget);
      });
    });
  });
  group("Password", () {
    String shortPassword = 'Password should be at least 6 characters';
    String longPassword = 'Password should not be more than 27';
    test.testWidgets("short Password", (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.enterText(password, "ahmad");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(shortPassword), test.findsOneWidget);
      });
    });
    test.testWidgets("long Password", (test.WidgetTester tester) async {
      await tester.runAsync(() async {
        await buildWidget(tester);
        await tester.pumpAndSettle();
        await tester.enterText(password, "ahmadahmadahmadahmadahmadahmad");
        await tester.tap(signInButton);
        await tester.pumpAndSettle();
        expect(test.find.text(longPassword), test.findsOneWidget);
      });
    });
  });
}
