import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreMenu {
  var db = FirebaseFirestore.instance;

  // Get full menu
  Future<List> getFullMenuList() async {
    CollectionReference menuRef = db.collection("menu");
    List documents = [];
    await menuRef.get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        documents.add(docSnapshot.data());
      }
    });

    return documents;
  }

  // Get menu based on tags
  Future<List> getTagMenuList({required String tag}) async {
    tag = tag.toLowerCase();
    CollectionReference menuRef = db.collection("menu");
    List documents = [];
    await menuRef.where("tags", arrayContains: tag).get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        documents.add(docSnapshot.data());
      }
    });
    return documents;
  }

  // Search for items
  Future<List> getSearchedMenuList(String search) async {
    search = search.toLowerCase();
    CollectionReference menuRef = db.collection("menu");
    List documents = [];
    // Search in tags
    await menuRef
        .where("tags", arrayContains: search)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        documents.add(docSnapshot.data());
      }
    });
// Search in name
    await menuRef
        .where("item_name", isEqualTo: search)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        documents.add(docSnapshot.data());
      }
    });
    // Search in ingredients
    await menuRef
        .where("ingredients", arrayContains: search)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        documents.add(docSnapshot.data());
      }
    });
    return documents;
  }

  // Search for veg/ non-veg
  Future<List> getVegNonVegMenuList(bool isVeg) async {
    CollectionReference menuRef = db.collection("menu");
    List documents = [];
    await menuRef.where("is_veg", isEqualTo: isVeg).get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        documents.add(docSnapshot.data());
      }
    });

    return documents;
  }

  // Search for categoryu
  Future<List> getCategoryMenuList(String category) async {
    category = category.toLowerCase();
    CollectionReference menuRef = db.collection("menu");
    List documents = [];
    await menuRef
        .where("category", isEqualTo: category)
        .get()
        .then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        documents.add(docSnapshot.data());
      }
    });

    return documents;
  }

  Future<List> getItemNames() async {
    List<String> items = [];
    CollectionReference menuRef = db.collection("menu");
    await menuRef.get().then((querySnapshot) {
      querySnapshot.docs.map((e) => items.add(e["item_name"]));
    });
    return items;
  }

  Future<void> increaseLike(String item_name) async {
    List<DocumentReference> documents = [];
    CollectionReference menuRef = db.collection("menu");
    await menuRef.where("item_name", isEqualTo: item_name).get().then((value) {
      for (var doc in value.docs) {
        documents.add(doc.reference);
      }
    });

    await documents[0].update({"likes": FieldValue.increment(1)});
  }

  Future<void> decreaseLike(String item_name) async {
    List<DocumentReference> documents = [];
    CollectionReference menuRef = db.collection("menu");
    await menuRef.where("item_name", isEqualTo: item_name).get().then((value) {
      for (var doc in value.docs) {
        documents.add(doc.reference);
      }
    });

    await documents[0].update({"likes": FieldValue.increment(-1)});
  }

  Future<List> getLikedItems(List likedItem) async {
    List documents = [];
    CollectionReference menuRef = db.collection("menu");
    for (var item_name in likedItem) {
      await menuRef
          .where("item_name", isEqualTo: item_name)
          .get()
          .then((querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          documents.add(docSnapshot.data());
        }
      });
    }
    return documents;
  }
}
