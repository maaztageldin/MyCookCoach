import 'package:flutter/material.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/local_entity.dart';

class LocationItemCard extends StatelessWidget {
  const LocationItemCard({
    Key? key,
    required this.local,
    required this.press,
  }) : super(key: key);

  final LocalEntity local;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 480,
                width: 480,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: local.imageUrl.isNotEmpty
                        ? NetworkImage(local.imageUrl)
                        : AssetImage("assets/shop/images/chef_img.png")
                            as ImageProvider,
                    // Sinon utilise l'image locale
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: kDefaultPaddin / 4, horizontal: kDefaultPaddin / 4),
              child: Text(
                local.name,
                style: const TextStyle(color: kTextLightColor),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 4),
              child: Text(
                local.address,
                style: const TextStyle(color: kTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
