import 'package:flutter/material.dart';
import 'package:mycookcoach/features/shop/domain/entities/order_entity.dart';

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({super.key, required this.order, required this.press});

  final OrderEntity order;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Commande #${order.orderNumber}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Date : ${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
