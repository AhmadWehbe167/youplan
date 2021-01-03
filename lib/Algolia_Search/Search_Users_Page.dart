import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:youplan/Algolia_Search/Models/Models.dart';
import 'package:youplan/Algolia_Search/display_Search_results.dart';
import 'package:youplan/Constants_and_Data/Constants.dart';
import 'package:youplan/Main_Layout/My_Drawer.dart';
import 'package:youplan/Profile/Profile_Page.dart';

import 'AlgoliaSearch.dart';

class SearchUsersBar extends StatefulWidget {
  SearchUsersBar({Key key}) : super(key: key);

  @override
  _SearchUsersBarState createState() => _SearchUsersBarState();
}

class _SearchUsersBarState extends State<SearchUsersBar> {
  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  String _searchTerm;

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("Users").search(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: background,
      drawer: MyDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: headerBottomColor,
        elevation: 5,
        title: Text(
          'Search',
          style: kTitleText,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          TextField(
              onChanged: (val) {
                setState(() {
                  _searchTerm = val;
                });
              },
              style: new TextStyle(color: Colors.white, fontSize: width * 0.06),
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search for your friends ...',
                  hintStyle: TextStyle(color: Color(0xFFD9DFE3)),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFFD9DFE3)))),
          Expanded(
            child: StreamBuilder<List<AlgoliaObjectSnapshot>>(
              stream: Stream.fromFuture(_operation(_searchTerm)),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    width: width * 0.8,
                    height: height * 0.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/SearchPage.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                } else {
                  List<AlgoliaObjectSnapshot> currSearchStuff = snapshot.data;

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
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
                                  SearchUser searchUser =
                                      SearchUser(currSearchStuff, index);
                                  return _searchTerm.length > 0
                                      ? DisplaySearchResult(
                                          fullName: searchUser.getFullName(),
                                          userName: searchUser.getUserName(),
                                          receiverId: searchUser.getObjectID(),
                                          fun: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilePage(
                                                  userID:
                                                      searchUser.getObjectID(),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : Container();
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
          ),
        ],
      ),
    );
  }
}
