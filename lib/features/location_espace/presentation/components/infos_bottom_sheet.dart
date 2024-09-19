
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/kitchen_location_entity.dart';

class InfosBottomSheet {
  static void show(BuildContext context, KitchenLocationEntity kitchen) {
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
        return _buildInfoContent(kitchen);
      },
    );
  }


  static Widget _buildInfoContent(KitchenLocationEntity kitchen) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              kitchen.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            kitchen.details,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: kTextLightColor),
          ),
        ],
      ),
    );
  }
}
