import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirestoreUser {
  var db = FirebaseFirestore.instance;

  addGoogleUserToDb(GoogleSignInAccount account) async {
    CollectionReference userRef = db.collection("users");
    print("Im in ....\nyo I'm in...");
    AggregateQuerySnapshot noAccount = await userRef
        .where('Document ID', isEqualTo: account.email)
        .count()
        .get();
    if (noAccount.count == 0) {
      userRef
          .doc(account.email)
          .set({"name": account.displayName, "favorites": []});
    }
  }

  addEmailUserToDb(UserCredential credential) async {
    CollectionReference userRef = db.collection("users");
    var noAccount = await userRef
        .where('Document ID', isEqualTo: credential.user!.email.toString())
        .count()
        .get();
    print("No. of accounts: " + noAccount.count.toString());
    if (noAccount.count == 0) {
      userRef
          .doc(credential.user!.email)
          .set({"name": credential.user!.displayName, "favorites": []});
    }
  }
}
