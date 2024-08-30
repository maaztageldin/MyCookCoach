import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/authentication/data/repositories/firebase_user_repo.dart';
import 'package:mycookcoach/features/shop/domain/entities/cart_item_entity.dart';
import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_bloc.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_event.dart';

class AddToCart extends StatelessWidget {
  const AddToCart({super.key, required this.product, required this.quantity});

  final KitchenItemEntity product;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseUserRepo().currentUser!.uid;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: kDefaultPaddin),
            height: 50,
            width: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFD3A984),
              ),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                "assets/shop/icons/add_to_cart.svg",
                colorFilter: ColorFilter.mode(const Color(0xFFD3A984), BlendMode.srcIn),
              ),
              onPressed: () {
                final cartItem = CartItemEntity.fromKitchenItem(product, quantity, userId);
                context.read<CartBloc>().add(AddCartItemEvent(item: cartItem));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} a été ajouté au panier'),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                backgroundColor: const Color(0xFFD3A984),
              ),
              child: Text(
                "Acheter".toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
