part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class RegisterRequested implements AuthEvent {
  final String email;
  final String password;

  RegisterRequested(this.email, this.password);
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
