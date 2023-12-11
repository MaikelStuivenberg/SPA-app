import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_app/features/user/models/user.dart';

class UserDataRepository {
  Future<User> getUser() async {
    var user = await getFirebaseUser();

    final prefs = await SharedPreferences.getInstance();
    // final firstname = prefs.getString('user_firstname');
    // final lastname = prefs.getString('user_lastname');
    // final age = prefs.getString('user_age');
    // final major = prefs.getString('user_major');
    // final minor = prefs.getString('user_minor');
    final image = prefs.getString('user_image') != null
        ? base64Decode(prefs.getString('user_image')!)
        : null;

    return User(
      firstname: user.data()!['firstname'] as String,
      lastname: user.data()!['lastname'] as String,
      age: user.data()!['age'] as String,
      major: user.data()!['major'] as String,
      minor: user.data()!['minor'] as String,
      image: image,
    );
  }

  Future<void> updateUser(User user) async {
    // final prefs = await SharedPreferences.getInstance();
    // if (user.firstname != null) {
    //   await prefs.setString('user_firstname', user.firstname!);
    // }
    // if (user.lastname != null) {
    //   await prefs.setString('user_lastname', user.lastname!);
    // }
    // if (user.age != null) {
    //   await prefs.setString('user_age', user.age!);
    // }
    // if (user.major != null) {
    //   await prefs.setString('user_major', user.major!);
    // }
    // if (user.minor != null) {
    //   await prefs.setString('user_minor', user.minor!);
    // }

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

  Future<void> setImage(Uint8List imageBytes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_image', base64Encode(imageBytes));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getFirebaseUser() async {
    var user = await FirebaseFirestore.instance
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
