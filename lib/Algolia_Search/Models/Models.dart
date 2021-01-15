import 'package:algolia/algolia.dart';

class SearchUser {
  final List<AlgoliaObjectSnapshot> snapshot;
  final int index;
  SearchUser(
    this.snapshot,
    this.index,
  );

  String getFullName() {
    return snapshot[index].data["fullName"];
  }

  String getUserName() {
    return snapshot[index].data["userName"];
  }

  String getObjectID() {
    return snapshot[index].objectID;
  }
}
