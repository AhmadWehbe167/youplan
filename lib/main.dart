import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Authenticate_Screens/Welcome/SplashScreen.dart';
import 'package:youplan/shared/Something_Went_wrong_page.dart';
import 'package:youplan/shared/loading.dart';

import 'Model/User.dart';
import 'services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SomethingWentWrong();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamProvider<Muser>.value(
              value: AuthServices(auth: FirebaseAuth.instance).userStream,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(),
                home: IntroScreen(),
              ),
            );
          }
          return MaterialApp(
            home: Loading(),
          );
        });
  }
}
