part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class OrderAddRequest extends OrderEvent {
  final MenuItem item;
  final int quantity;

  OrderAddRequest({required this.item, required this.quantity});
}

class OrderRemoveRequest extends OrderEvent {
  final MenuItem item;

  OrderRemoveRequest({required this.item});
}
