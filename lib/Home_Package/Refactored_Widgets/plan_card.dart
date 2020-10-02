import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Home_Package/Refactored_Widgets/Multiple_Styles_Text.dart';
import 'package:youplan/Model/User.dart';
import 'package:youplan/Requests/PLan_Requests/ViewPlan.dart';

class PlanCard extends StatefulWidget {
  final userDoc;
  final User user;
  final GlobalKey<ScaffoldState> globalKey;
  final ctxt;
  final index;
  final String creatorFullName;
  final date;
  final String location;
  final String title;
  final String leftButtonText;
  final String rightButtonText;
  final Function leftButtonFun;
  final Function rightButtonFun;

  PlanCard({
    Key key,
    @required this.userDoc,
    @required this.user,
    @required this.globalKey,
    @required this.ctxt,
    @required this.index,
    @required this.creatorFullName,
    @required this.date,
    @required this.location,
    @required this.title,
    @required this.leftButtonText,
    @required this.rightButtonText,
    @required this.leftButtonFun,
    @required this.rightButtonFun,
  }) : super(key: key);

  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  String checkImage(String type) {
    if (type == 'Food & Drink') {
      return 'FoodDrink';
    } else if (type == 'Concerts & Shows') {
      return 'ConcertsShows';
    } else if (type == 'Entertainment') {
      return 'Entertainment';
    } else if (type == 'Cultural & Arts') {
      return 'CulturalArt';
    } else {
      return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _acceptTextStyle = TextStyle(
      fontSize: 20,
      fontFamily: 'ConcertOne',
      color: Colors.green[400],
    );
    TextStyle _rejectTextStyle = TextStyle(
      fontSize: 20,
      fontFamily: 'ConcertOne',
      color: Colors.red[400],
    );
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    double detailSize = height * 0.023;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            widget.ctxt,
            MaterialPageRoute(
                builder: (context) => ViewPlan(
                      title: widget.userDoc[widget.index]['title'],
                      type: widget.userDoc[widget.index]['type'],
                      uid: widget.userDoc[widget.index]['creator uid'],
                      place: widget.userDoc[widget.index]['place'],
                      selectedDate: DateFormat('yMd').format(
                          widget.userDoc[widget.index]['date'].toDate()),
                      fullName: widget.userDoc[widget.index]
                          ['creator fullName'],
                      userName: widget.userDoc[widget.index]
                          ['creator userName'],
                      isCreator: widget.userDoc[widget.index]['isCreator'],
                      description: widget.userDoc['description'],
                      index: widget.index,
                      notes: widget.userDoc[widget.index]['notes'],
                    )));
      },
      child: Card(
        margin: EdgeInsets.all(8),
        color: Colors.teal,
        elevation: 7,
        child: Container(
          height: height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: height * 0.02,
              ),
              Expanded(
                flex: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Expanded(
                      child: Container(
                        // height: height * 0.16,
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(
                                'images/${checkImage(widget.userDoc[widget.index]['type'])}.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(5)),
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    widget.title.toUpperCase(),
                                    style: TextStyle(
                                        fontFamily: 'ConcertOne',
                                        fontSize: 25,
                                        color: navy),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.teal[700],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Expanded(
                                        child: MulStylesText(
                                          definition: 'Creator',
                                          value: widget.creatorFullName,
                                          fontSize: detailSize,
                                        ),
                                      ),
                                      Expanded(
                                        child: MulStylesText(
                                          definition: 'Date',
                                          value: DateFormat('yyyy-MM-dd')
                                              .format(widget.date),
                                          fontSize: detailSize,
                                        ),
                                      ),
                                      widget.location != null
                                          ? Expanded(
                                              child: MulStylesText(
                                                definition: 'Location',
                                                value: widget.location,
                                                fontSize: detailSize,
                                              ),
                                            )
                                          : Expanded(
                                              child: Container(),
                                            ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(width * 0.007),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          onPressed: widget.leftButtonFun,
                          color: Colors.white,
                          padding: EdgeInsets.only(bottom: height * 0.01),
                          child: Text(
                            widget.leftButtonText,
                            style: _acceptTextStyle,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.007,
                      ),
                      Expanded(
                        child: FlatButton(
                          padding: EdgeInsets.only(bottom: height * 0.01),
                          color: Colors.white,
                          onPressed: widget.rightButtonFun,
                          child: Text(
                            widget.rightButtonText,
                            style: _rejectTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
