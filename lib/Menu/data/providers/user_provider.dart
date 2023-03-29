import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'menu_provider.dart';

class FirestoreUser {
  var db = FirebaseFirestore.instance;
  var firestoreMenu = FirestoreMenu();

  addGoogleUserToDb(GoogleSignInAccount account) async {
    CollectionReference userRef = db.collection("users");
    AggregateQuerySnapshot noAccount = await userRef
        .where('Document ID', isEqualTo: account.email)
        .count()
        .get();
    if (noAccount.count == 0) {
      await userRef
          .doc(account.email)
          .set({"name": account.displayName, "favorites": []});
    }
  }

  addEmailUserToDb({required String name, required String email}) async {
    CollectionReference userRef = db.collection("users");
    var noAccount =
        await userRef.where('Document ID', isEqualTo: email).count().get();
    print("No. of accounts: " + noAccount.count.toString());
    if (noAccount.count == 0) {
      await userRef.doc(email).set({"name": name, "favorites": []});
    }
  }

  likeItem(String email, String item_name) async {
    var userRef = db.collection("users").doc(email);
    await userRef.update({
      "favorites": FieldValue.arrayUnion([item_name])
    });
    await firestoreMenu.increaseLike(item_name);
  }

  removeLikeFromItem(String email, String item_name) async {
    var userRef = db.collection("users").doc(email);
    await userRef.update({
      "favorites": FieldValue.arrayRemove([item_name])
    });
    await firestoreMenu.decreaseLike(item_name);
  }

  Future<List> getLikedItems(String email) async {
    List favorites = [];
    DocumentReference user = db.collection("users").doc(email);
    await user.get().then((value) {
      final data = value.data() as Map<String, dynamic>;
      favorites = data["favorites"];
      print(data);
    }, onError: (e) => print(e));
    print(favorites);
    return favorites;
  }
}
