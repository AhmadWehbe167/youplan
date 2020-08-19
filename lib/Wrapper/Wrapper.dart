import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Authenticate_Screens/Authenticate_Wrapper.dart';
import 'package:youplan/Main_Layout/Main_Layout.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/shared/loading.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool loading = true;
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (loading) {
      return LogoLoading();
    } else if (user == null) {
      return Authentication();
    } else {
      return MainPageLayout();
    }
  }
}
