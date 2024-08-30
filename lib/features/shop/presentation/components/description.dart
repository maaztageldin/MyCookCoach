import 'package:flutter/material.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';

class Description extends StatelessWidget {
  const Description({super.key, required this.product});

  final KitchenItemEntity product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Text(
        product.description,
        style: const TextStyle(height: 1.5),
      ),
    );
  }
}
