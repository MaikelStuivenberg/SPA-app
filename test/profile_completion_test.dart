import 'package:flutter_test/flutter_test.dart';
import 'package:spa_app/core/router/profile_completion.dart';
import 'package:spa_app/ui/features/user/models/user.dart';

void main() {
  group('needsOnboarding', () {
    test('returns true when firstname is null or empty', () {
      expect(needsOnboarding(UserData()), isTrue);
      expect(needsOnboarding(UserData(firstname: '')), isTrue);
      expect(needsOnboarding(UserData(firstname: '   ')), isTrue);
    });

    test('returns false when onboarding is explicitly complete', () {
      expect(
        needsOnboarding(
          UserData(firstname: 'Alex', onboardingComplete: true),
        ),
        isFalse,
      );
    });

    test('returns true when name is set but onboarding is not complete', () {
      expect(
        needsOnboarding(
          UserData(firstname: 'Alex', onboardingComplete: false),
        ),
        isTrue,
      );
    });

    test('legacy users with a name and no flag skip onboarding', () {
      expect(needsOnboarding(UserData(firstname: 'Alex')), isFalse);
    });
  });
}
