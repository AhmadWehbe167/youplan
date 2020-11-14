import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Authenticate_Screens/Sign_in_Page.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/services/auth.dart';

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

class AuthServicesMock extends Mock implements AuthServices {
  final FirebaseAuthMock firebaseAuthMock;
  AuthServicesMock({this.firebaseAuthMock});
}

class UserMock extends Mock implements User {}

void main() async {
  final String randomUid = "jalkdjkajdkajkdljakjdklajlkd";
  final FirebaseAuthMock firebaseAuthMock = FirebaseAuthMock();
  final AuthServicesMock authServices = AuthServicesMock(
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

  var emailField = find.byType(TextField).first;
  var passwordField = find.byType(TextField).last;
  var signInButton = find.text('Log In');

  group("Testing Log In functionality", () {
    testWidgets("Log In", (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(makeTestable(
          SignInPage(
            auth: authServices,
            height: 683.4285714285714,
            width: 411.42857142857144,
          ),
        ));
        await tester.pumpAndSettle();
        await tester.tap(emailField);
        await tester.enterText(emailField, "Email");

        expect(emailField, findsOneWidget);
      });
    });
  });
}
