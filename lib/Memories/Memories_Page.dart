import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youplan/Home_Package/Refactored_Widgets/plan_card.dart';
import 'package:youplan/Model/User.dart';

class MemoriesPage extends StatefulWidget {
  final String type;
  const MemoriesPage({
    Key key,
    this.type,
  }) : super(key: key);

  @override
  _MemoriesPageState createState() => _MemoriesPageState();
}

class _MemoriesPageState extends State<MemoriesPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Memories')
            .document(user.uid)
            .collection('categories')
            .document(widget.type)
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
                  return widget.type != 'Challenges'
                      ? PlanCard(
                          imageTitle: 'restaurant',
                          title: userDoc[index]['title'],
                          type: userDoc[index]['title'],
                          date: userDoc[index]['date'].toDate(),
                          locationDescription: userDoc[index]['place'] ?? '',
                          isPLan: false,
                          elevate: true,
                        )
                      : ChallengeCard(
                          imageTitle: 'Nature',
                          title: userDoc[index]['title'],
                          description: userDoc[index]['description'],
                          notes: userDoc[index]['notes'],
                          elevate: true,
                        );
                });
          }
        });
  }
}
