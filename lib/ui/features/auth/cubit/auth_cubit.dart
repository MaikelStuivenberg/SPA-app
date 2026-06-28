import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/core/di/injection.dart';
import 'package:spa_app/data/services/auth_service.dart';
import 'package:spa_app/domain/repositories/user_repository.dart';
import 'package:spa_app/ui/features/user/models/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({AuthService? authService, UserRepository? userRepository})
      : _authService = authService ?? getIt<AuthService>(),
        _userRepository = userRepository ?? getIt<UserRepository>(),
        super(AuthStateInitial());

  final AuthService _authService;
  final UserRepository _userRepository;

  Future<void> loginUsernamePassword(String email, String password) async {
    emit(AuthStateLoading());

    try {
      final auth = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );

      if (auth.user == null) throw Exception('User not found');

      emit(AuthStateSuccess(await _userRepository.getUser()));
    } catch (e) {
      emit(AuthStateError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _userRepository.clearSessionCache();
    emit(AuthStateInitial());
  }

  Future<void> loginApple() async {
    emit(AuthStateLoading());

    try {
      await _authService.signInWithApple();
      emit(AuthStateSuccess(await _userRepository.getUser()));
    } on Exception catch (e) {
      if (kDebugMode) print('exception->$e');
    }
  }

  Future<void> loginGoogle() async {
    emit(AuthStateLoading());

    try {
      await _authService.signInWithGoogle();
      emit(AuthStateSuccess(await _userRepository.getUser()));
    } on Exception catch (e) {
      if (kDebugMode) print('exception->$e');
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthStateLoading());

    await _authService.createUserWithEmailAndPassword(email, password);
    await loginUsernamePassword(email, password);
  }

  Future<bool> tryAutoLogin() async {
    if (_authService.currentUser == null) return false;

    emit(AuthStateSuccess(await _userRepository.getUser()));
    return true;
  }

  Future<void> updateUserData(UserData userData) async {
    final current = state;
    final merged = current is AuthStateSuccess
        ? current.user.mergedWith(userData)
        : userData;

    await _userRepository.updateUser(merged);
    emit(AuthStateSuccess(merged));
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthStateLoading());
    try {
      await _authService.sendPasswordResetEmail(email);
      emit(AuthStateInitial());
    } catch (e) {
      emit(AuthStateError(e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    emit(AuthStateLoading());
    try {
      if (_authService.currentUser == null) {
        throw Exception('No user logged in');
      }
      await _userRepository.deleteCurrentUserData();
      await _authService.deleteCurrentUser();
      _userRepository.clearSessionCache();
      emit(AuthStateInitial());
    } catch (e) {
      emit(AuthStateError(e.toString()));
    }
  }
}
