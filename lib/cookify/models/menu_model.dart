// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class MenuItem {
  final String item_name;
  final String description;
  final String image;
  final List ingredients;
  final bool is_veg;
  final num likes;
  final num price;
  final List tags;

  MenuItem(this.item_name, this.description, this.image, this.ingredients,
      this.is_veg, this.likes, this.price, this.tags);

  // factory MenuItem.fromMap(Map<String, dynamic> map) {
  //   return MenuItem(
  //       item_name: map["item_name"],
  //       description: map["description"],
  //       image: map["image"],
  //       ingredients: map["ingredients"],
  //       is_veg: map["is_veg"],
  //       likes: map["likes"],
  //       price: map["price"],
  //       tags: map["tags"]);
  // }

  MenuItem copyWith({
    String? item_name,
    String? description,
    String? image,
    List<String>? ingredients,
    bool? is_veg,
    num? likes,
    num? price,
    List<String>? tags,
  }) {
    return MenuItem(
      item_name ?? this.item_name,
      description ?? this.description,
      image ?? this.image,
      ingredients ?? this.ingredients,
      is_veg ?? this.is_veg,
      likes ?? this.likes,
      price ?? this.price,
      tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item_name': item_name,
      'description': description,
      'image': image,
      'ingredients': ingredients,
      'is_veg': is_veg,
      'likes': likes,
      'price': price,
      'tags': tags,
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
        map['item_name'] as String,
        map['description'] as String,
        map['image'] as String,
        map['ingredients'] as List,
        map['is_veg'] as bool,
        map['likes'] as num,
        map['price'] as num,
        map['tags'] as List);
  }

  String toJson() => json.encode(toMap());

  factory MenuItem.fromJson(String source) =>
      MenuItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MenuItem(item_name: $item_name, description: $description, image: $image, ingredients: $ingredients, is_veg: $is_veg, likes: $likes, price: $price, tags: $tags)';
  }

  @override
  bool operator ==(covariant MenuItem other) {
    if (identical(this, other)) return true;

    return other.item_name == item_name &&
        other.description == description &&
        other.image == image &&
        listEquals(other.ingredients, ingredients) &&
        other.is_veg == is_veg &&
        other.likes == likes &&
        other.price == price &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return item_name.hashCode ^
        description.hashCode ^
        image.hashCode ^
        ingredients.hashCode ^
        is_veg.hashCode ^
        likes.hashCode ^
        price.hashCode ^
        tags.hashCode;
  }
}

class Menu {
  final List<MenuItem> menuItems;

  Menu({required this.menuItems});
}
