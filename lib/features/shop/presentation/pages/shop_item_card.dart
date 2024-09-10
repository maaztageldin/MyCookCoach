import 'package:flutter/material.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.product, required this.press});

  final KitchenItemEntity product;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(kDefaultPaddin),
              decoration: BoxDecoration(
                color: const Color(0xFFD3A984),
                //const Color(0xFF989493)//product.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${product.id}",
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset("assets/shop/images/chef_img.png");
                        },
                      )
                    : Image.asset("assets/shop/images/chef_img.png"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              // products is out demo list
              product.name,
              style: const TextStyle(color: kTextLightColor),
            ),
          ),
          Text(
            "\€${product.price}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
