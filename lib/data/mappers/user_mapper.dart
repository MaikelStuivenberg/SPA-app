import 'package:spa_app/ui/features/user/models/user.dart';

class UserMapper {
  UserMapper._();

  static UserData fromFirestore(String id, Map<String, dynamic> data) {
    return UserData(
      id: id,
      firstname: data['firstname'] as String? ?? '',
      lastname: data['lastname'] as String? ?? '',
      age: data['age'] as String? ?? '',
      major: data['major'] as String? ?? '',
      minor: data['minor'] as String? ?? '',
      image: data['image'] as String? ?? '',
      biblestudyGroup: data['biblestudyGroup'] as String?,
      biblestudyLeader: data['biblestudyLeader'] as bool?,
      tent: data['tent'] as String?,
      tentLeader: data['tentLeader'] as bool?,
      staff: data['staff'] as bool?,
      onboardingComplete: data['onboardingComplete'] as bool?,
    );
  }
}
