import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';
import 'package:mycookcoach/features/shop/domain/repositories/kitchen_item_repository.dart';

class KitchenItemRepositoryImpl implements KitchenItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<KitchenItemEntity>> fetchKitchenItems() async {
    try {
      final querySnapshot = await _firestore.collection('kitchen_items').get();
      return querySnapshot.docs
          .map((doc) => KitchenItemEntity.fromDocument(doc))
          .toList();
    } catch (e) {
      // Log the error or handle it accordingly
      throw Exception('Failed to fetch kitchen items: $e');
    }
  }

  @override
  Future<void> addKitchenItem(KitchenItemEntity item) async {
    try {
      await _firestore
          .collection('kitchen_items')
          .doc(item.id)
          .set(item.toDocument());
    } catch (e) {
      throw Exception('Failed to add kitchen item: $e');
    }
  }

  @override
  Future<void> updateKitchenItem(KitchenItemEntity item) async {
    try {
      await _firestore
          .collection('kitchen_items')
          .doc(item.id)
          .update(item.toDocument());
    } catch (e) {
      throw Exception('Failed to update kitchen item: $e');
    }
  }

  @override
  Future<void> deleteKitchenItem(String itemId) async {
    try {
      await _firestore.collection('kitchen_items').doc(itemId).delete();
    } catch (e) {
      throw Exception('Failed to delete kitchen item: $e');
    }
  }

  @override
  Future<List<KitchenItemEntity>> fetchKitchenItemsByCategory(
      String category) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot;
      if (category == "Tous") {
        querySnapshot = await _firestore.collection('kitchen_items').get();
      } else {
        querySnapshot = await _firestore
            .collection('kitchen_items')
            .where('category', isEqualTo: category)
            .get();
      }

      return querySnapshot.docs
          .map((doc) => KitchenItemEntity.fromDocument(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch kitchen items by category: $e');
    }
  }
}
