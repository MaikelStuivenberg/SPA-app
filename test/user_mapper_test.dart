import 'package:spa_app/data/mappers/user_mapper.dart';
import 'package:spa_app/ui/features/user/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserMapper', () {
    test('maps firestore data to UserData', () {
      final user = UserMapper.fromFirestore('uid-1', {
        'firstname': 'Jane',
        'lastname': 'Doe',
        'age': '20',
        'major': 'Brass',
        'minor': 'Ritme',
        'image': 'photo.jpg',
        'biblestudyGroup': 'A',
        'biblestudyLeader': true,
        'tent': 'T1',
        'tentLeader': false,
        'staff': true,
        'onboardingComplete': false,
      });

      expect(user.id, 'uid-1');
      expect(user.firstname, 'Jane');
      expect(user.staff, isTrue);
      expect(user.biblestudyLeader, isTrue);
      expect(user.onboardingComplete, isFalse);
    });
  });
}
