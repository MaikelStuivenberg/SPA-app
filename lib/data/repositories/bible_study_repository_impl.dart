import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spa_app/domain/repositories/bible_study_repository.dart';

class BibleStudyRepositoryImpl implements BibleStudyRepository {
  BibleStudyRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getContent() {
    return _firestore.collection('biblestudy').get();
  }
}
