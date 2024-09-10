import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_bloc.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_event.dart';

import 'cart_counter.dart';

class CounterWithFavBtn extends StatelessWidget {
  CounterWithFavBtn({
    super.key,
    required this.productId,
    required this.onQuantityChanged,
    required this.numOfItems, required this.userId,
  });

  final String productId;
  final String userId;
  final Function(int) onQuantityChanged;
  late int numOfItems;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CartCounter(
          onQuantityChanged: (int quantity) {
            onQuantityChanged(quantity);
            context
                .read<CartBloc>()
                .add(RecalculateTotalEvent(quantity, productId, userId));
            print('Quantity changed: $quantity');
          },
          numOfItems: numOfItems,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          height: 32,
          width: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFFF6464),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset("assets/shop/icons/heart.svg"),
        )
      ],
    );
  }
}
