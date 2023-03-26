import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_management/cookify/models/Order_model.dart';
import 'package:restaurant_management/cookify/models/menu_model.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(Orders(orders: [])) {
    on<OrderAddRequest>((event, emit) {
      List<OrderItem> prev = state.orders;
      OrderItem newItem = OrderItem(event.item, event.quantity);
      if (prev.contains(newItem)) {
        emit(OrderAdded(orders: prev));
      } else {
        prev.add(OrderItem(event.item, event.quantity));
        emit(OrderAdded(orders: prev));
      }
    });
  }
}
