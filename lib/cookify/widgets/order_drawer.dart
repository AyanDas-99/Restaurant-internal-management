import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_management/flutx/lib/widgets/svg/svg.dart';
import 'package:restaurant_management/logic/bloc/order_bloc.dart';

import '../models/Order_model.dart';

class Order_drawer extends StatelessWidget {
  const Order_drawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          print(state);
        },
        builder: (context, state) {
          if (state.orders.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FxSvg(
                  'assets/images/undraw_breakfast_psiw.svg',
                  size: 100,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Your plate is empty\n\nAdd something for order",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Colors.grey),
                  textAlign: TextAlign.center,
                )
              ],
            );
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
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(item.item.image),
        ),
        title: Text(item.item.item_name),
        subtitle: Text("Quantity: ${item.quantity.toString()}"),
        trailing: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                context.read<OrderBloc>().add(OrderRemoveRequest(item: item));
              },
              icon: Icon(Icons.remove));
        }));
  }
}
