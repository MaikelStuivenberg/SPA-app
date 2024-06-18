import 'package:cloud_firestore/cloud_firestore.dart';

class ProgramDataRepository {
  Future<QuerySnapshot<Map<String, dynamic>>> getProgram() async {
    return FirebaseFirestore.instance.collection('program').get();
  }
}
