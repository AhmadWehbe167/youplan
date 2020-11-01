import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewPlan extends StatefulWidget {
  final String uid;
  final String userName;
  final String fullName;
  final String title;
  final String type;
  final String selectedDate;
  final String place;
  final String description;
  final String notes;
  final bool isCreator;
  final int index;
  const ViewPlan({
    this.title,
    this.type,
    this.uid,
    this.place,
    this.notes,
    this.description,
    this.selectedDate,
    this.isCreator,
    this.userName,
    this.fullName,
    this.index,
  });
  @override
  _ViewPlanState createState() => _ViewPlanState();
}

class _ViewPlanState extends State<ViewPlan> {
  TextStyle _style = TextStyle(fontSize: 20);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Lobster',
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Requests')
                      .doc(widget.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Text('No Data'));
                    } else {
                      var userDoc = snapshot.data['plans'];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Title is: ${widget.title}',
                            style: _style,
                          ),
                          Text(
                            'type is: ${widget.type}',
                            style: _style,
                          ),
                          Text(
                            'description is: ${widget.description}',
                            style: _style,
                          ),
                          Text(
                            'place is: ${widget.place}',
                            style: _style,
                          ),
                          Text(
                            'date is: ${widget.selectedDate}',
                            style: _style,
                          ),
                          Text(
                            'uid is: ${widget.uid}',
                            style: _style,
                          ),
                          Text(
                            'notes are: ${widget.notes}',
                            style: _style,
                          ),
                          Text(
                            'isCreator: ${widget.isCreator}',
                            style: _style,
                          ),
                        ],
                      );
                    }
                  }),
              SizedBox(
                height: 50,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('planNames')
                      .doc(widget.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Text('no data'));
                    } else {
                      var userDoc = snapshot.data;
                      return Column(
                        children: <Widget>[
                          Text(
                            'invited friends are:${userDoc['${widget.title} Invited Friends']}',
                            style: _style,
                          ),
                          Text(
                            'accepted friends are:${userDoc['${widget.title} friends Accepted']}',
                            style: _style,
                          ),
                        ],
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
