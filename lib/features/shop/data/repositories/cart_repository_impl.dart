import 'package:mycookcoach/features/shop/domain/entities/cart_item_entity.dart';
import 'package:mycookcoach/features/shop/domain/repositories/cart_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartRepositoryImpl implements CartRepository {
  final FirebaseFirestore firestore =  FirebaseFirestore.instance;

  @override
  Future<List<CartItemEntity>> getCartItems() async {
    final snapshot = await firestore.collection('cartItems').get();
    return snapshot.docs.map((doc) => CartItemEntity.fromDocument(doc)).toList();
  }

  @override
  Future<void> addCartItem(CartItemEntity item) async {
    await firestore.collection('cartItems').doc(item.id).set(item.toDocument());
  }

  @override
  Future<void> updateCartItem(CartItemEntity item) async {
    await firestore.collection('cartItems').doc(item.id).update(item.toDocument());
  }

  @override
  Future<void> deleteCartItem(String itemId) async {
    await firestore.collection('cartItems').doc(itemId).delete();
  }

  @override
  Future<CartItemEntity?> getCartItemByUserIdAndProductId(String userId, String productId) async {
    try {
      final querySnapshot = await firestore
          .collection('cartItems')
          .where('userId', isEqualTo: userId)
          .where('id', isEqualTo: productId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return CartItemEntity.fromDocument(querySnapshot.docs.first);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'élément du panier : $e');
    }
  }
}
