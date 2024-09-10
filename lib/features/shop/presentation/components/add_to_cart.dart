import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/authentication/data/repositories/firebase_user_repo.dart';
import 'package:mycookcoach/features/shop/domain/entities/cart_item_entity.dart';
import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';
import 'package:mycookcoach/features/shop/infrastructure/shop_service.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_bloc.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_event.dart';
import 'package:mycookcoach/features/shop/presentation/components/build_purchase_button.dart';

class AddToCart extends StatelessWidget {
  AddToCart({super.key, required this.product, required this.quantity});

  final KitchenItemEntity product;
  final int quantity;
  final ShopService shopService = ShopService();


  @override
  Widget build(BuildContext context) {
    final String userId = FirebaseUserRepo().currentUser!.uid;

    final Map<KitchenItemEntity, int> products = {
      product: quantity
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Row(
        children: <Widget>[
          _buildAddToCartButton(context, userId),
          BuildPurchaseButton(context, userId, products),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context, String userId) {
    return Container(
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
          colorFilter:
          const ColorFilter.mode(Color(0xFFD3A984), BlendMode.srcIn),
        ),
        onPressed: () async {
          await _handleAddToCart(context, userId);
        },
      ),
    );
  }

  Future<void> _handleAddToCart(BuildContext context, String userId) async {
    int? stockQuantity = await shopService.getStockQuantity(product.id);

    final cartItem = CartItemEntity.fromKitchenItem(product, quantity, userId);

    if (stockQuantity != null && quantity <= stockQuantity) {
      context.read<CartBloc>().add(AddCartItemEvent(item: cartItem));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFD3A984),
          content: Text(
            'Vous avez ajouté $quantity ${product.name} au panier',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFD3A984),
          content: Text(
            'Désolé, seulement $stockQuantity ${product.name} est disponible en stock.',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
}
