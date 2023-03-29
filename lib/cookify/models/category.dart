import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category {
  final IconData icon;
  final String title;

  Category(this.icon, this.title);

  static List<Category> getList() {
    return [
      Category(Icons.shelves, "All"),
      Category(Icons.icecream, "Desert"),
      Category(FontAwesomeIcons.bowlFood, "Snack"),
      Category(Icons.cake, "Cake"),
      Category(FontAwesomeIcons.cloudMeatball, "Chicken"),
    ];
  }
}
