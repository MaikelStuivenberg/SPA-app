import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spa_app/domain/repositories/program_repository.dart';

class ProgramRepositoryImpl implements ProgramRepository {
  ProgramRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getProgram() {
    return _firestore.collection('program').get();
  }
}
