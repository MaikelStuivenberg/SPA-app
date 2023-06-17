import 'package:cloud_firestore/cloud_firestore.dart';

class Biblestudy {
  Timestamp? date;
  String? content;
  String? tagline;
  String? title;
  String? type;

  static Biblestudy createFromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> d,) {
    final biblestudy = Biblestudy();
    // biblestudy.date = d.get('date');
    // biblestudy.tagline = d.get('tagline');
    // biblestudy.title = d.get('title');
    // biblestudy.type = d.get('type');
    // biblestudy.content = d.get('content');

    return biblestudy;
  }
}
