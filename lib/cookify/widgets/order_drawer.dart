import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/logic/bloc/order_bloc.dart';

import '../models/Order_model.dart';

class Order_drawer extends StatelessWidget {
  const Order_drawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.orders.isEmpty) {
            return Text("Empty");
          }
          return Column(
            children: _buildOrderList(state.orders),
          );
        },
      ),
    );
  }

  _buildOrderList(List<OrderItem> list) {
    List<Widget> orderItems = [];
    for (OrderItem item in list) {
      orderItems.add(OrderListItem(item));
    }
    return orderItems;
  }

  Widget OrderListItem(OrderItem item) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(item.item.image),
        ),
        Text(item.item.item_name),
        Text(item.quantity.toString())
      ],
    );
  }
}
