import 'package:flutter/material.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/local_entity.dart';

class LocationItemCard extends StatelessWidget {
  const LocationItemCard({
    Key? key,
    required this.local,
    required this.press,
  }) : super(key: key);

  final LocalEntity local; // LocalEntity à la place de KitchenItemEntity
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white, // Fond blanc
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(kDefaultPaddin),
                decoration: BoxDecoration(
                  color: const Color(0xFFD3A984),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Hero(
                  tag: "${local.id}",
                  // Pour l'image, ici tu peux ajouter un champ image dans LocalEntity si tu en as
                  child: Image.asset(
                    "assets/shop/images/chef_img.png", // Placeholder pour local
                    fit: BoxFit.cover, // S'assurer que l'image est bien ajustée
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
              child: Text(
                local.name, // Affichage du nom du local
                style: const TextStyle(color: kTextLightColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: kDefaultPaddin / 2),
              child: Text(
                local.address, // Affichage de l'adresse du local
                style: const TextStyle(color: kTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

