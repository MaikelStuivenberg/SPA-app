import 'dart:typed_data';

import 'package:spa_app/ui/features/user/models/user.dart';

abstract class UserRepository {
  Future<UserData> getUser();
  Future<void> updateUser(UserData user);
  Future<void> setProfileImage(Uint8List imageBytes);
  Future<String> getCurrentUserId();
  Future<void> deleteCurrentUserData();
  Future<List<UserData>> getUsersByIds(List<String> userIds);
  void clearSessionCache();
}
