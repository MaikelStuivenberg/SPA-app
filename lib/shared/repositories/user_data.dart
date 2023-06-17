import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:spa_app/features/user/models/user.dart';

class UserDataRepository {
  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final firstname = prefs.getString('user_firstname');
    final lastname = prefs.getString('user_lastname');
    final age = prefs.getString('user_age');
    final major = prefs.getString('user_major');
    final minor = prefs.getString('user_minor');
    final image = prefs.getString('user_image') != null
        ? base64Decode(prefs.getString('user_image')!)
        : null;

    return User(
      firstname: firstname,
      lastname: lastname,
      age: age,
      major: major,
      minor: minor,
      image: image,
    );
  }

  Future<void> setUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    if (user.firstname != null) {
      await prefs.setString('user_firstname', user.firstname!);
    }
    if (user.lastname != null) {
      await prefs.setString('user_lastname', user.lastname!);
    }
    if (user.age != null) {
      await prefs.setString('user_age', user.age!);
    }
    if (user.major != null) {
      await prefs.setString('user_major', user.major!);
    }
    if (user.minor != null) {
      await prefs.setString('user_minor', user.minor!);
    }
  }

  Future<void> setImage(Uint8List imageBytes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_image', base64Encode(imageBytes));
  }
}
