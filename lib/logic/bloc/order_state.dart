part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  final List<OrderItem> orders;
  const OrderState({required this.orders});

  @override
  List<Object> get props => [orders];
}

class Orders extends OrderState {
  final List<OrderItem> orders;
  Orders({required this.orders}) : super(orders: orders);
}
