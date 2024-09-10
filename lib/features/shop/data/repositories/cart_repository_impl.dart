import 'package:mycookcoach/features/shop/domain/entities/cart_item_entity.dart';
import 'package:mycookcoach/features/shop/domain/repositories/cart_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartRepositoryImpl implements CartRepository {
  final FirebaseFirestore firestore =  FirebaseFirestore.instance;

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

  @override
  Future<List<CartItemEntity>> getCartItemsByUserId(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('cartItems')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((doc) => CartItemEntity.fromDocument(doc))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des éléments du panier : $e');
    }
  }


  @override
  Future<void> updateCartItemQuantityByIdAndUserId(String productId, String userId, int newQuantity) async {
    try {
      final querySnapshot = await firestore
          .collection('cartItems')
          .where('userId', isEqualTo: userId)
          .where('id', isEqualTo: productId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;

        if (newQuantity > 0) {
          await firestore.collection('cartItems').doc(doc.id).update({'quantity': newQuantity});
        } else {
          await firestore.collection('cartItems').doc(doc.id).delete();
        }
      } else {
        throw Exception('Article non trouvé dans le panier.');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la quantité de l\'article du panier : $e');
    }
  }

  @override
  Future<void> removeCartItemByIdAndUserId(String productId, String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('cartItems')
          .where('userId', isEqualTo: userId)
          .where('id', isEqualTo: productId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        await firestore.collection('cartItems').doc(doc.id).delete();
      } else {
        throw Exception('Article non trouvé dans le panier.');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'article du panier : $e');
    }
  }

  @override
  Future<void> clearCartByUserIdAndProductId(String userId) async {
    try {
      await firestore
          .collection('cartItems')
          .where('userId', isEqualTo: userId)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
    } catch (e) {
      throw Exception("Erreur lors de la suppression de tous les articles du panier");
    }
  }

}
