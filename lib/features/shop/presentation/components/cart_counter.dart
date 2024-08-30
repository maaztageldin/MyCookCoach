import 'package:flutter/material.dart';
import 'package:mycookcoach/core/utils/constents.dart';

class CartCounter extends StatefulWidget {
  final Function(int) onQuantityChanged;
  late int numOfItems;

  CartCounter(
      {super.key, required this.onQuantityChanged, required this.numOfItems});

  @override
  State<CartCounter> createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
  void _updateQuantity(int quantity) {
    setState(() {
      widget.numOfItems = quantity;
      widget.onQuantityChanged(widget.numOfItems);
      // _updateCartTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 40,
          height: 32,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            onPressed: () {
              if (widget.numOfItems > 1) {
                _updateQuantity(widget.numOfItems - 1);
              }
            },
            child: const Icon(Icons.remove),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
          child: Text(
            widget.numOfItems.toString().padLeft(2, "0"),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          width: 40,
          height: 32,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            onPressed: () {
              _updateQuantity(widget.numOfItems + 1);
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
