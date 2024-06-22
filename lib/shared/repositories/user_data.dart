import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:spa_app/features/user/models/user.dart';

class UserDataRepository {
  Future<UserData> getUser() async {
    final user = await getFirebaseUser();

    return UserData(
      id: FirebaseAuth.instance.currentUser!.uid,
      firstname: user.data()!['firstname'] as String,
      lastname: user.data()!['lastname'] as String,
      age: user.data()!['age'] as String,
      major: user.data()!['major'] as String,
      minor: user.data()!['minor'] as String,
      image: user.data()!['image'] as String,
    );
  }

  Future<void> updateUser(UserData user) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'firstname': user.firstname,
      'lastname': user.lastname,
      'age': user.age,
      'major': user.major,
      'minor': user.minor,
    });
  }

  Future<void> setProfileImage(Uint8List imageBytes) async {
    final datestamp = DateTime.now().year.toString() +
        DateTime.now().month.toString() +
        DateTime.now().day.toString() +
        DateTime.now().hour.toString() +
        DateTime.now().minute.toString() +
        DateTime.now().second.toString() +
        DateTime.now().millisecond.toString();

    await FirebaseStorage.instance
        .ref()
        .child('users')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('profile')
        .child(datestamp)
        .putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'image': datestamp,
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getFirebaseUser() async {
    final user = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (user.exists == false) {
      // Create a new firebase user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'firstname': '',
        'lastname': '',
        'age': '',
        'major': '',
        'minor': '',
        'image': '',
      });

      return getFirebaseUser();
    }

    return user;
  }
}
