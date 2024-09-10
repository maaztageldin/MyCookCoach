import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/kitchen_item_bloc/kitchen_item_bloc.dart';
import 'package:mycookcoach/features/shop/presentation/blocs/kitchen_item_bloc/kitchen_item_event.dart';

class ShopService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int?> getStockQuantity(String kitchenItemId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('kitchen_items')
          .doc(kitchenItemId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        return data['stockQuantity'] as int;
      } else {
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération du stockQuantity: $e');
      return null;
    }
  }

  Future<void> updateStockQuantity(BuildContext context, String kitchenItemId, int quantity) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef =
      _firestore.collection('kitchen_items').doc(kitchenItemId);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot<Map<String, dynamic>> snapshot = await transaction.get(docRef);

        if (!snapshot.exists) {
          throw Exception("Produit non trouvé");
        }

        int currentStockQuantity = snapshot.data()!['stockQuantity'] as int;
        int newStockQuantity = currentStockQuantity - quantity;

        if (newStockQuantity < 0) {
          throw Exception("Quantité en stock insuffisante");
        }

        if (newStockQuantity == 0) {
          context.read<KitchenItemBloc>().add(DeleteKitchenItemEvent(kitchenItemId));
        }

        transaction.update(docRef, {'stockQuantity': newStockQuantity});
      });
    } catch (e) {
      print('Erreur lors de la mise à jour du stock: $e');
    }
  }

  Future<KitchenItemEntity?> getKitchenItemById(String kitchenItemId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('kitchen_items')
          .doc(kitchenItemId)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        return KitchenItemEntity.fromDocument(snapshot);
      } else {
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération du produit: $e');
      return null;
    }
  }

  Future<int> getHighestOrderNumber() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('orders')
          .orderBy('orderNumber', descending: true)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        return data['orderNumber'] as int;
      } else {
        return 0;
      }
    } catch (e) {
      print('Erreur lors de la récupération du numéro de commande le plus élevé: $e');
      return 0;
    }
  }
}
