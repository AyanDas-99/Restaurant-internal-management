import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management/cookify/models/Order_model.dart';
import 'package:restaurant_management/cookify/models/menu_model.dart';
import 'package:restaurant_management/flutx/lib/extensions/string_extension.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(Orders(orders: [])) {
    on<OrderAddRequest>((event, emit) {
      List<OrderItem> prev = state.orders;
      OrderItem newItem = OrderItem(event.item, event.quantity);
      if (prev.contains(newItem)) {
        emit(Orders(
          orders: prev,
        ));
      } else {
        emit(Orders(
          orders: [...state.orders, OrderItem(event.item, event.quantity)],
        ));
      }
    });

    on<OrderRemoveRequest>((event, emit) {
      List<OrderItem> prev = List.from(state.orders)..remove(event.item);
      emit(Orders(
        orders: prev,
      ));
    });
  }
}
