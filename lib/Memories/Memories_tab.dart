import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Model/User.dart';

class MemoriesTab extends StatefulWidget {
  final String type;
  const MemoriesTab({
    Key key,
    this.type,
  }) : super(key: key);

  @override
  _MemoriesTabState createState() => _MemoriesTabState();
}

class _MemoriesTabState extends State<MemoriesTab> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Muser>(context);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Memories')
            .doc(user.uid)
            .collection('categories')
            .doc(widget.type)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('no data'));
          } else {
            var userDoc = widget.type == 'Challenges'
                ? snapshot.data['challenges']
                : snapshot.data['plans'];
            return ListView.builder(
                itemCount: userDoc.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Container();
                  // PlanCard(
                  //       title: userDoc[index]['title'],
                  //       type: userDoc[index]['title'],
                  //       date: userDoc[index]['date'].toDate(),
                  //       locationDescription: userDoc[index]['place'] ?? '',
                  //       isPLan: false,
                  //       elevate: true,
                  //     )
                });
          }
        });
  }
}
