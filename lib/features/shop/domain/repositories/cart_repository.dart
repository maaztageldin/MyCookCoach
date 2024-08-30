import 'package:mycookcoach/features/shop/domain/entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<List<CartItemEntity>> getCartItems();
  Future<void> addCartItem(CartItemEntity item);
  Future<void> updateCartItem(CartItemEntity item);
  Future<void> deleteCartItem(String itemId);
  Future<CartItemEntity?> getCartItemByUserIdAndProductId(String userId, String productId);
}
