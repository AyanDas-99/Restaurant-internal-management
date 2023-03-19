import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FAuth {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

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

  // Google Login
  Future<void> googleLogIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      await firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      throw e;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }

    try {
      await _googleSignIn.signOut();
    } catch (e) {
      print(e);
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
