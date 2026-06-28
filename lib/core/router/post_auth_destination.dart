import 'package:spa_app/core/router/profile_completion.dart';
import 'package:spa_app/core/router/route_paths.dart';
import 'package:spa_app/ui/features/auth/cubit/auth_cubit.dart';

String postAuthDestination(AuthState authState) {
  if (authState is AuthStateSuccess && needsOnboarding(authState.user)) {
    return RoutePaths.onboarding;
  }
  return RoutePaths.home;
}
