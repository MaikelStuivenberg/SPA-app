part of 'auth_cubit.dart';

abstract class AuthState {
  const AuthState();

  List<Object> get props => [];
}

class AuthStateInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthStateLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthStateError extends AuthState {
  const AuthStateError(this.errorMessage);

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}

class AuthStateSuccess extends AuthState {
  const AuthStateSuccess(this.user);

  final UserData user;

  @override
  List<Object> get props => [user];
}
