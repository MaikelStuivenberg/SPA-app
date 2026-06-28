import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spa_app/data/services/auth_service.dart';
import 'package:spa_app/domain/repositories/user_repository.dart';
import 'package:spa_app/ui/features/auth/cubit/auth_cubit.dart';
import 'package:spa_app/ui/features/user/models/user.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockAuthService authService;
  late MockUserRepository userRepository;

  setUpAll(() {
    registerFallbackValue(UserData());
  });

  setUp(() {
    authService = MockAuthService();
    userRepository = MockUserRepository();
    when(() => userRepository.updateUser(any())).thenAnswer((_) async {});
  });

  blocTest<AuthCubit, AuthState>(
    'updateUserData does not emit loading',
    build: () => AuthCubit(
      authService: authService,
      userRepository: userRepository,
    ),
    seed: () => AuthStateSuccess(
      UserData(
        id: 'uid-1',
        firstname: 'Alex',
        onboardingComplete: false,
      ),
    ),
    act: (cubit) => cubit.updateUserData(
      UserData(firstname: 'Alex', lastname: 'Kim'),
    ),
    expect: () => [
      isA<AuthStateSuccess>()
          .having((s) => s.user.firstname, 'firstname', 'Alex')
          .having((s) => s.user.lastname, 'lastname', 'Kim')
          .having((s) => s.user.id, 'id', 'uid-1')
          .having((s) => s.user.onboardingComplete, 'onboardingComplete', false),
    ],
    verify: (_) {
      verify(
        () => userRepository.updateUser(
          any(
            that: isA<UserData>()
                .having((u) => u.firstname, 'firstname', 'Alex')
                .having((u) => u.lastname, 'lastname', 'Kim')
                .having((u) => u.id, 'id', 'uid-1'),
          ),
        ),
      ).called(1);
    },
  );
}
