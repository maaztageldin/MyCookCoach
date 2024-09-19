import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/shop/domain/entities/order_entity.dart';
import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';
import 'package:mycookcoach/features/shop/infrastructure/shop_service.dart';

class OrdersDetailsScreen extends StatefulWidget {
  final OrderEntity order;

  const OrdersDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  _OrdersDetailsScreenState createState() => _OrdersDetailsScreenState();
}

class _OrdersDetailsScreenState extends State<OrdersDetailsScreen> {
  final ShopService _shopService = ShopService();
  Map<String, KitchenItemEntity> _productDetails = {};

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    Map<String, KitchenItemEntity> productDetails = {};
    for (var productId in widget.order.products.keys) {
      var product = await _shopService.getKitchenItemById(productId);
      if (product != null) {
        productDetails[productId] = product;
      }
    }
    setState(() {
      _productDetails = productDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/shop/icons/back.svg',
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Commande No: ${widget.order.orderNumber}',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statut de la commande
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Text(
                    widget.order.status,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Total : ${widget.order.totalPrice}€',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Liste des produits
            Expanded(
              child: _productDetails.isNotEmpty
                  ? ListView.separated(
                itemCount: widget.order.products.length,
                itemBuilder: (context, index) {
                  String productId =
                  widget.order.products.keys.elementAt(index);
                  KitchenItemEntity? product = _productDetails[productId];
                  int quantity = widget.order.products[productId]!;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product?.name ?? 'Produit inconnu',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Quantité : $quantity',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${product?.price ?? '0'}€',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                const SizedBox(height: 10),
              )
                  : const Center(
                child: CircularProgressIndicator(color: kMainColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
