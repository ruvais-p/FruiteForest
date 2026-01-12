part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class OtpSentSuccess extends AuthState {}

final class AuthSuccess extends AuthState {
  final int flow; // 0 = login, 1 = profile setup, 2 = home
  AuthSuccess(this.flow);
}

final class ProfileCreatedSuccess extends AuthState {}

final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
