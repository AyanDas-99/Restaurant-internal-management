import 'package:firebase_auth/firebase_auth.dart';

class FAuth {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Email Register user
  Future<void> registerWithEmail(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception(e);
    }
  }

  // Email login
  Future<void> loginWithEmail(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  // Forgot password
  Future<void> forgotPassword({required String email}) async {
    try {
      firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e);
    }
  }
}
