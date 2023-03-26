part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  final List<OrderItem> orders;
  const OrderState({required this.orders});

  @override
  List<Object> get props => [];
}

class Orders extends OrderState {
  final List<OrderItem> orders;
  Orders({required this.orders}) : super(orders: orders);
}

class OrderAdded extends OrderState {
  final List<OrderItem> orders;
  OrderAdded({required this.orders}) : super(orders: orders);
}

class OrderRemoved extends OrderState {
  final List<OrderItem> orders;
  OrderRemoved({required this.orders}) : super(orders: orders);
}
