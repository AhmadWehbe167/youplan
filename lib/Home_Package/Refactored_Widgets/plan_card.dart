import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Multiple_Styles_Text.dart';

class PlanCard extends StatefulWidget {
  final String imageTitle;
  final String title;
  final String type;
  final DateTime date;
  final String locationDescription;
  final bool isPLan;
  final bool elevate;
  const PlanCard({
    Key key,
    @required this.imageTitle,
    @required this.title,
    @required this.type,
    @required this.date,
    @required this.locationDescription,
    @required this.isPLan,
    @required this.elevate,
  });
  @override
  _PlanCardState createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/${widget.imageTitle}.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontFamily: 'ArchitectsDaughter',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: MulStylesText(
                        definition: 'Type',
                        value: widget.type,
                      ),
                    ),
                    Expanded(
                      child: MulStylesText(
                        definition: widget.isPLan ? 'Date' : 'Deadline',
                        value: DateFormat('yMd').format(widget.date),
                      ),
                    ),
                    Expanded(
                      child: MulStylesText(
                        definition: widget.isPLan ? 'Location' : 'Description',
                        value: widget.locationDescription,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChallengeCard extends StatefulWidget {
  final String imageTitle;
  final String title;
  final String description;
  final String notes;
  final bool elevate;
  const ChallengeCard({
    Key key,
    @required this.imageTitle,
    @required this.title,
    @required this.description,
    @required this.notes,
    @required this.elevate,
  });
  @override
  _ChallengeCardState createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/${widget.imageTitle}.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontFamily: 'ArchitectsDaughter',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: MulStylesText(
                        definition: 'description',
                        value: widget.description,
                      ),
                    ),
                    Expanded(
                      child: MulStylesText(
                        definition: 'notes',
                        value: widget.notes,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
