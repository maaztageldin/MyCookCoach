import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/features/authentication/data/repositories/firebase_user_repo.dart';
import 'package:mycookcoach/features/shop/domain/entities/cart_item_entity.dart';
import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';
import 'package:mycookcoach/features/shop/infrastructure/shop_service.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_bloc.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_event.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_state.dart';
import 'package:mycookcoach/features/shop/presentation/components/build_purchase_button.dart';

class CartBottomSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (BuildContext context) {
        return BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CartsLoadedState && state.items.isNotEmpty) {
              return _buildCartContent(context, state.items);
            } else {
              return _buildEmptyCart();
            }
          },
        );
      },
    );
  }

  static Widget _buildCartContent(
      BuildContext context, List<CartItemEntity> items) {
    final String userId = FirebaseUserRepo().currentUser!.uid;
    final ShopService shopService = ShopService();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Votre panier",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        items[index].imageUrl.isNotEmpty
                            ? Image.network(
                                items[index].imageUrl,
                                width: 50,
                                height: 50,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/shop/images/chef_img.png",
                                    width: 50,
                                    height: 50,
                                  );
                                },
                              )
                            : Image.asset(
                                "assets/shop/images/chef_img.png",
                                width: 50,
                                height: 50,
                              ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                items[index].name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Quantité : ${items[index].quantity}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove,
                              size: 18, color: Color(0xFFD3A984)),
                          onPressed: () {
                            int newQuantity = items[index].quantity - 1;
                            if (newQuantity > 0) {
                              context.read<CartBloc>().add(
                                    UpdateCartItemQuantityByIdAndUserIdEvent(
                                      productId: items[index].id,
                                      newQuantity: newQuantity,
                                      userId: userId,
                                    ),
                                  );
                            } else {
                              context.read<CartBloc>().add(
                                    RemoveCartItemByIdAndUserIdEvent(
                                      productId: items[index].id,
                                      userId: userId,
                                    ),
                                  );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add,
                              size: 18, color: Color(0xFFD3A984)),
                          onPressed: () async {
                            int? stockQuantity = await shopService
                                .getStockQuantity(items[index].id);
                            int currentQuantity = items[index].quantity;
                            if (stockQuantity != null &&
                                currentQuantity < stockQuantity) {
                              context.read<CartBloc>().add(
                                    UpdateCartItemQuantityByIdAndUserIdEvent(
                                      productId: items[index].id,
                                      newQuantity: currentQuantity + 1,
                                      userId: userId,
                                    ),
                                  );
                            } else {
                              _showStockLimitPopup(
                                  context, stockQuantity, items[index].name);
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              size: 18, color: Color(0xFFD3A984)),
                          onPressed: () {
                            context.read<CartBloc>().add(
                                  RemoveCartItemByIdAndUserIdEvent(
                                    productId: items[index].id,
                                    userId: userId,
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              Map<KitchenItemEntity, int> products = {};

              for (var item in items) {
                final kitchenItem =
                    await shopService.getKitchenItemById(item.id);
                if (kitchenItem != null) {
                  products[kitchenItem] = item.quantity;
                }
              }

              ShowPurchaseModal(context, products, userId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD3A984),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text(
              "Valider le panier",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildEmptyCart() {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Votre panier est vide",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            "Ajoutez des produits à votre panier pour les voir ici.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  static void _showStockLimitPopup(
      BuildContext context, int? stockQuantity, String itemName) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Stock Limité', style: TextStyle(color: Colors.white)),
          content: Text(
            'Désolé, seulement $stockQuantity $itemName disponible en stock.',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Color(0xFFD3A984),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
