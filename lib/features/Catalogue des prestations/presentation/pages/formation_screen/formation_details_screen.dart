import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/formation_entity.dart';

class FormationDetailsScreen extends StatelessWidget {
  final FormationEntity formation;

  const FormationDetailsScreen({Key? key, required this.formation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(formation.title),
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/shop/icons/back.svg',
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: formation.imageUrl.isNotEmpty
                        ? NetworkImage(formation.imageUrl)
                        : AssetImage("assets/shop/images/chef_img.png") as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              Text(
                formation.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),

              Text(
                formation.description,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16.0),

              Text(
                "Prix: ${formation.price} €",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),

              Text(
                "Durée: ${formation.duration}",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),

              ...[
              Text(
                "Début: ${formation.startDate.year}-${formation.startDate.month}-${formation.startDate.day}",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                "Fin: ${formation.endDate.year}-${formation.endDate.month}-${formation.endDate.day}",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],

              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
