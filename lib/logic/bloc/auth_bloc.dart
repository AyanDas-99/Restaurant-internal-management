import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:restaurant_management/data/provider/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FAuth fAuth = FAuth();
  AuthBloc({required FAuth}) : super(AuthUnAuthenticated()) {
    // Register Request
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await fAuth.registerWithEmail(
            email: event.email, password: event.password, name: event.name);
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // Login request
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await fAuth.loginWithEmail(
            email: event.email, password: event.password);
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    //Sign out request
    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await fAuth.signOut();
        emit(AuthUnAuthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // Password Reset Request
    on<PasswordResetRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await fAuth.forgotPassword(email: event.email);
        emit(PassResetEmailSent());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // GoogleSignIn request
    on<GoogleSignInRequested>((event, emit) async {
      emit(GoogleLoginLoading());
      try {
        await fAuth.googleLogIn();
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
