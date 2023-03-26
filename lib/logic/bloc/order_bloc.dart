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
      prev.add(OrderItem(event.item, event.quantity));
    });
  }
}
