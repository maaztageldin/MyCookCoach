import 'package:cloud_firestore/cloud_firestore.dart';

class ShopRepository {
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
}
