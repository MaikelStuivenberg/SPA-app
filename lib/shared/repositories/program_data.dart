import 'package:cloud_firestore/cloud_firestore.dart';

class ProgramDataRepository {
  // Save user as static variable
  static QuerySnapshot<Map<String, dynamic>>? _program;

  Future<QuerySnapshot<Map<String, dynamic>>> getProgram({
    bool forceReload = false,
  }) async {
    if (_program != null && forceReload == false) {
      return Future.value(_program!);
    }

    return _program =
        await FirebaseFirestore.instance.collection('program').get();
  }
}
