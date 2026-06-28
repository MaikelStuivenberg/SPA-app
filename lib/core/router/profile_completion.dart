import 'package:spa_app/ui/features/user/models/user.dart';

bool needsOnboarding(UserData user) {
  if (user.onboardingComplete == true) return false;
  if (user.onboardingComplete == false) return true;

  // Legacy profiles without the field: only gate on missing first name.
  return user.firstname == null || user.firstname!.trim().isEmpty;
}
