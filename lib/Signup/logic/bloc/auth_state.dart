part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnAuthenticated extends AuthState {}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}

class PassResetEmailSent extends AuthState {}

class GoogleLoginLoading extends AuthState {}
