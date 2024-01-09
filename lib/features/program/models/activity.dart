import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  Timestamp? date;
  String? title;
  String? location;
  Map<String, dynamic>? requirements;
  String? image;
  String? link;

  static Activity createFromDoc(QueryDocumentSnapshot<Map<String, dynamic>> d) {
    final activity = Activity()
      ..date = d.get('date') as Timestamp
      ..location = d.get('location') as String
      ..title = d.get('title') as String
      ..image = d.get('image') as String
      ..requirements = d.data().containsKey('requirements') &&
              d.get('requirements').toString().isNotEmpty
          ? d.get('requirements') as Map<String, dynamic>
          : null;

    if (d.data().containsKey('link') && d.get('link').toString().isNotEmpty) {
      activity.link = d.get('link') as String;
    }

    return activity;
  }
}
