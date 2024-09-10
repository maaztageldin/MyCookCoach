import 'package:flutter/material.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';

class ProductTitleWithImage extends StatelessWidget {
  const ProductTitleWithImage({super.key, required this.product});

  final KitchenItemEntity product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            product.category,
            style: TextStyle(color: Colors.white,),
          ),
          Text(
            product.name,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: kDefaultPaddin),
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(text: "Prix\n"),
                    TextSpan(
                      text: "\€${product.price}",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: kDefaultPaddin + 20),
              Expanded(
                child: Hero(
                  tag: "${product.id}",
                  child: product.imageUrl.isNotEmpty
                      ? Image.network(
                    product.imageUrl,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("assets/shop/images/chef_img.png");
                    },
                  )
                      : Image.asset("assets/shop/images/chef_img.png"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
