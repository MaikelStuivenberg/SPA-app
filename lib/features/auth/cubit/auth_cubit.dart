import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spa_app/app/injection/injection.dart';
import 'package:spa_app/features/user/models/user.dart';
import 'package:spa_app/shared/repositories/user_data.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthStateInitial());

  Future<void> loginUsernamePassword(String email, String password) async {
    emit(AuthStateLoading());

    try {
      final auth = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (auth.user == null) throw Exception('User not found');

      emit(AuthStateSuccess(await getIt<UserDataRepository>().getUser()));
    } catch (e) {
      emit(AuthStateError(e.toString()));
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    emit(AuthStateInitial());
  }

  Future<void> loginApple() async {
    emit(AuthStateLoading());

    try {
      await FirebaseAuth.instance.signInWithProvider(AppleAuthProvider());

      emit(AuthStateSuccess(await getIt<UserDataRepository>().getUser()));
    } on Exception catch (e) {
      if (kDebugMode) print('exception->$e');
    }
  }

  Future<void> loginGoogle() async {
    emit(AuthStateLoading());

    try {
      await GoogleSignIn().signIn().then((googleUser) async {
        final googleAuth = await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        emit(AuthStateSuccess(await getIt<UserDataRepository>().getUser()));
      });
    } on Exception catch (e) {
      if (kDebugMode) print('exception->$e');
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthStateLoading());

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await loginUsernamePassword(email, password);
  }

  Future<bool> tryAutoLogin() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return false;

    emit(AuthStateSuccess(await getIt<UserDataRepository>().getUser()));

    return true;
  }

  Future<void> updateUserData(UserData userData) async {
    emit(AuthStateLoading());

    await getIt<UserDataRepository>().updateUser(userData);

    emit(AuthStateSuccess(userData));
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthStateLoading());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(AuthStateInitial()); // Or create a new state if you want to show a success message
    } catch (e) {
      emit(AuthStateError(e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    emit(AuthStateLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user logged in');
      await getIt<UserDataRepository>().deleteCurrentUserData();
      await user.delete();
      emit(AuthStateInitial());
    } catch (e) {
      emit(AuthStateError(e.toString()));
    }
  }
}
