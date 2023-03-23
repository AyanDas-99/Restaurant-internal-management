part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class RegisterRequested implements AuthEvent {
  final String email;
  final String password;
  final String name;

  RegisterRequested(this.email, this.password, this.name);
}

class LoginRequested implements AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class SignOutRequested implements AuthEvent {}

class PasswordResetRequested implements AuthEvent {
  final String email;

  PasswordResetRequested(this.email);
}

class GoogleSignInRequested implements AuthEvent {}
