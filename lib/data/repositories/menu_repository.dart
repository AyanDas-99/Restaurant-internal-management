import '../../cookify/models/menu_model.dart';

class MenuRepository {
  Future<Menu> getFullMenu(Function request) async {
    var docs = await request();
    List<MenuItem> list = docs
        .map<MenuItem>((e) => MenuItem.fromMap({
              'item_name': e["item_name"],
              'description': e["description"],
              'image': e["image"],
              'ingredients': e["ingredients"],
              'is_veg': e["is_veg"],
              'likes': e["likes"],
              'price': e["price"],
              'tags': e["tags"],
            }))
        .toList();
    return Menu(menuItems: list);
  }

  Future<Menu> getMenu(Function request, String cat) async {
    var docs = await request(cat);
    List<MenuItem> list = docs
        .map<MenuItem>((e) => MenuItem.fromMap({
              'item_name': e["item_name"],
              'description': e["description"],
              'image': e["image"],
              'ingredients': ["", ""],
              'is_veg': e["is_veg"],
              'likes': e["likes"],
              'price': e["price"],
              'tags': e["tags"],
            }))
        .toList();
    return Menu(menuItems: list);
  }
}
