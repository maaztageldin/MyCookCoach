import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/core/services/payment_service/stripe_service.dart';
import 'package:mycookcoach/features/shop/data/repositories/order_repository_impl.dart';
import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';
import 'package:mycookcoach/features/shop/domain/usecases/orders_usecases/create_order.dart';
import 'package:mycookcoach/features/shop/infrastructure/shop_service.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_bloc.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/cart_item_bloc/cart_items_event.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/orders_bloc/order_bloc.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/orders_bloc/order_event.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/orders_bloc/order_state.dart';

final ShopService shopService = ShopService();

Widget BuildPurchaseButton(
    BuildContext context, String userId, Map<KitchenItemEntity, int> products) {
  return BlocListener<PurchaseBloc, PurchaseState>(
    listener: (context, state) {
      if (state is PurchaseSuccess) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Paiement effectué avec succès!'),
            backgroundColor: Color(0xFFD3A984),
          ),
        );
      } else if (state is PurchaseFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error),
            backgroundColor: Color(0xFFD3A984),
          ),
        );
      }
    },
    child: Expanded(
      child: ElevatedButton(
        onPressed: () async {
          bool allProductsAvailable = true;
          for (var product in products.entries) {
            int? stockQuantity =
                await shopService.getStockQuantity(product.key.id);
            if (stockQuantity == null || product.value > stockQuantity) {
              allProductsAvailable = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFFD3A984),
                  content: Text(
                    'Désolé, seulement $stockQuantity ${product.key.name} est disponible en stock.',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
              break;
            }
          }

          if (allProductsAvailable) {
            ShowPurchaseModal(context, products, userId);
          }
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
  );
}

void ShowPurchaseModal(
    BuildContext context, Map<KitchenItemEntity, int> products, String userId) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddressFormFields(fullNameController, addressController,
                    cityController, postalCodeController),
                const SizedBox(height: 20),
                _buildPaymentButton(
                  context,
                  _formKey,
                  products,
                  userId,
                  fullNameController,
                  addressController,
                  cityController,
                  postalCodeController,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Column _buildAddressFormFields(
  TextEditingController fullNameController,
  TextEditingController addressController,
  TextEditingController cityController,
  TextEditingController postalCodeController,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Adresse d'expédition".toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      TextFormField(
        controller: fullNameController,
        decoration: const InputDecoration(
          labelText: 'Nom complet',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer votre nom complet';
          }
          return null;
        },
      ),
      const SizedBox(height: 10),
      TextFormField(
        controller: addressController,
        decoration: const InputDecoration(
          labelText: 'Adresse de livraison',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer votre adresse';
          }
          return null;
        },
      ),
      const SizedBox(height: 10),
      TextFormField(
        controller: cityController,
        decoration: const InputDecoration(
          labelText: 'Ville',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer votre ville';
          }
          return null;
        },
      ),
      const SizedBox(height: 10),
      TextFormField(
        controller: postalCodeController,
        decoration: const InputDecoration(
          labelText: 'Code postal',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer votre code postal';
          }
          if (value.length != 5) {
            return 'Le code postal doit contenir 5 chiffres';
          }
          return null;
        },
      ),
    ],
  );
}

ElevatedButton _buildPaymentButton(
  BuildContext context,
  GlobalKey<FormState> formKey,
  Map<KitchenItemEntity, int> products,
  String userId,
  TextEditingController fullNameController,
  TextEditingController addressController,
  TextEditingController cityController,
  TextEditingController postalCodeController,
) {
  int totalPrice = products.entries
      .map((entry) => int.parse(entry.key.price) * entry.value)
      .reduce((value, element) => value + element);

  return ElevatedButton(
    onPressed: () async {
      if (formKey.currentState!.validate()) {
        bool paymentSuccess = await StripeService.instance.makePayment(
          context,
          totalPrice,
        );

        if (paymentSuccess) {
          int _orderNumberCounter = await shopService.getHighestOrderNumber();

          context.read<PurchaseBloc>().add(
                PaymentConfirmed(
                  userId: userId,
                  products: products.map(
                      (product, quantity) => MapEntry(product.id, quantity)),
                  totalPrice: totalPrice,
                  fullName: fullNameController.text,
                  shippingAddress: addressController.text,
                  city: cityController.text,
                  postalCode: postalCodeController.text,
                  orderNumber: _orderNumberCounter+1,
                ),
              );

          for (var product in products.entries) {
            shopService.updateStockQuantity(
              context,
              product.key.id,
              product.value,
            );
          }

          context
              .read<CartBloc>()
              .add(ClearCartByUserIdAndProductIdEvent(userId: userId));

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color(0xFFD3A984),
              content: Text(
                'Paiement effectué avec succès!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    },
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, 48),
      backgroundColor: const Color(0xFFD3A984),
    ),
    child: Text(
      'Payer $totalPrice€',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
