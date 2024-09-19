import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycookcoach/core/services/database_service.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/kitchen_location_entity.dart';
import 'package:mycookcoach/features/location_espace/presentation/components/infos_bottom_sheet.dart';
import 'package:mycookcoach/features/location_espace/presentation/components/kitchen_image_carousel.dart';
import 'package:mycookcoach/features/location_espace/presentation/pages/reservation_screen.dart';

class KitchenLocationScreen extends StatelessWidget {
  final List<String> kitchenIds;

  const KitchenLocationScreen({Key? key, required this.kitchenIds})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DataBaseService dataBaseService = DataBaseService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/shop/icons/back.svg',
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Nos espaces',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<KitchenLocationEntity>>(
        future: dataBaseService.fetchKitchens(kitchenIds),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: kMainColor));
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune cuisine disponible."));
          } else {
            final kitchens = snapshot.data!;
            return ListView.builder(
              itemCount: kitchens.length,
              itemBuilder: (context, index) {
                return KitchenCard(kitchen: kitchens[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class KitchenCard extends StatelessWidget {
  final KitchenLocationEntity kitchen;

  const KitchenCard({Key? key, required this.kitchen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildTitle(context),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KitchenImageCarousel(images: kitchen.images),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildAvailability(),
                const Spacer(),
                _buildDetailsButtom(context, kitchen),
              ],
            ),
            const SizedBox(height: 10),
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            kitchen.name,
            style:
                const TextStyle(fontWeight: FontWeight.bold, color: kTextColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPrice() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Prix : ${kitchen.priceH} €/H",
        style: const TextStyle(
          color: kTextColor,
        ),
      ),
    );
  }

  Widget _buildAvailability() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        kitchen.availabilityPeriods.isNotEmpty ? "Disponible" : "Indisponible",
        style: TextStyle(
          fontSize: 12,
          color: kitchen.availabilityPeriods.isNotEmpty? Colors.green : kTextLightColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDetailsButtom(
      BuildContext context, KitchenLocationEntity kitchen) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        onPressed: () => InfosBottomSheet.show(context, kitchen),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: const BorderSide(
            color: Color(0xFF8B4513),
            width: 0.2,
          ),
        ),
        child: const Text(
          "Détails",
          style: TextStyle(
            fontSize: 12,
            color: kMainColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return OutlinedButton(
      onPressed: kitchen.isAvailable
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReservationScreen(kitchen: kitchen),
                ),
              );
            }
          : null,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        side: const BorderSide(
          color: kMainColor,
          width: 1,
        ),
      ),
      child: Text(
        "Réserver".toUpperCase(),
        style: const TextStyle(
          color:kMainColor,
        ),
      ),
    );
  }
}
