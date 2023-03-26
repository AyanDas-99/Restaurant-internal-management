// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:restaurant_management/cookify/models/menu_model.dart';

class OrderItem {
  final MenuItem item;
  final int quantity;

  OrderItem(this.item, this.quantity);

  @override
  bool operator ==(covariant OrderItem other) {
    if (identical(this, other)) return true;

    return other.item == item;
  }

  @override
  int get hashCode => item.hashCode ^ quantity.hashCode;
}
