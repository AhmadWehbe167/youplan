import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youplan/Algolia_Search/AlgoliaSearch.dart';
import 'package:youplan/Algolia_Search/display_Search_results.dart';
import 'package:youplan/shared/Shared_functions.dart';

class SearchFriendsBar extends StatefulWidget {
  final String uid;
  SearchFriendsBar({Key key, this.uid}) : super(key: key);

  @override
  _SearchFriendsBarState createState() => _SearchFriendsBarState();
}

class _SearchFriendsBarState extends State<SearchFriendsBar> {
  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  String _searchTerm;
  List<dynamic> uIds;

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("Users").search(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }

  getFriends() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Friends')
        .doc(widget.uid)
        .get();
    uIds = List.from(doc.data()['friends']);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getFriends();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            TextField(
                onChanged: (val) {
                  setState(() {
                    _searchTerm = val;
                  });
                },
                style: new TextStyle(color: Colors.black, fontSize: 20),
                decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search ...',
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: const Icon(Icons.search, color: Colors.black))),
            StreamBuilder<List<AlgoliaObjectSnapshot>>(
              stream: Stream.fromFuture(_operation(_searchTerm)),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Text(
                    "",
                    style: TextStyle(color: Colors.black),
                  );
                else {
                  List<AlgoliaObjectSnapshot> currSearchStuff = snapshot.data;

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container();
                    default:
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      else
                        return CustomScrollView(
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (_searchTerm.length > 0) {
                                    return userExists(
                                            currSearchStuff[index].objectID,
                                            uIds)
                                        ? DisplaySearchResult(
                                            fullName: currSearchStuff[index]
                                                .data["fullName"],
                                            userName: currSearchStuff[index]
                                                .data["userName"],
                                            receiverId:
                                                currSearchStuff[index].objectID,
                                          )
                                        : Container();
                                  } else {
                                    return Container();
                                  }
                                },
                                childCount: currSearchStuff.length ?? 0,
                              ),
                            ),
                          ],
                        );
                  }
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}
