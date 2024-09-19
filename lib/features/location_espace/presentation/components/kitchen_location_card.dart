import 'package:flutter/material.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/kitchen_location_entity.dart';

class KitchenLocationCard extends StatelessWidget {
  const KitchenLocationCard(
      {super.key, required this.kitechen, required this.press});

  final KitchenLocationEntity kitechen;
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
                color: const Color(0xFF8B4513),
                //const Color(0xFF989493)//product.color,
                borderRadius: BorderRadius.circular(16),
              ),
              /*child: Hero(
                tag: "${product.id}",
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                  product.imageUrl,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset("assets/shop/images/chef_img.png");
                  },
                )
                    : Image.asset("assets/shop/images/chef_img.png"),
              ),*/
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              // products is out demo list
              kitechen.name,
              style: const TextStyle(color: kTextLightColor),
            ),
          ),
          Text(
            "\€${kitechen.priceH}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
