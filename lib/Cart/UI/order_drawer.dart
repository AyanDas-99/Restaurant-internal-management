import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restaurant_management/flutx/lib/widgets/svg/svg.dart';
import 'package:restaurant_management/Cart/logic/bloc/order_bloc.dart';
import 'package:restaurant_management/theme/app_theme.dart';

import '../../cookify/models/Order_model.dart';

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
                  "Your plate is empty\nAdd something for order",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.grey),
                  textAlign: TextAlign.center,
                )
              ],
            );
          }
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Text(
                    "Your list",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ..._buildOrderList(state.orders),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStatePropertyAll(0),
                          padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(31, 64, 255, 80))),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.bowlFood,
                            color: CustomTheme.green,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Order",
                            style: TextStyle(color: CustomTheme.green),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _buildOrderList(List<OrderItem> list) {
    List<Widget> orderItems = [];
    for (OrderItem item in list) {
      orderItems.add(OrderListItem(item));
      orderItems.add(Divider());
    }
    return orderItems;
  }

  Widget OrderListItem(OrderItem item) {
    return ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Image.network(
            item.item.image,
            height: 40,
          ),
        ),
        title: Text(
          item.item.item_name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Text(
              "Quantity:",
              style: TextStyle(fontSize: 10),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.all(5),
              padding: const EdgeInsets.all(5.0),
              child: Text(
                item.quantity.toString(),
              ),
            )
          ],
        ),
        trailing: Builder(builder: (context) {
          return ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Color.fromARGB(35, 244, 67, 54),
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                context.read<OrderBloc>().add(OrderRemoveRequest(item: item));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Color.fromARGB(255, 255, 178, 178),
                    elevation: 0.0,
                    content: Text(
                      "Remove from list",
                      style: TextStyle(color: Colors.black),
                    ),
                    duration: Duration(milliseconds: 2000),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )));
              },
              child: Icon(
                Icons.remove,
                color: Colors.black,
              ));
        }));
  }
}
