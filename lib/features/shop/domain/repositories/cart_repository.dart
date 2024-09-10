import 'package:mycookcoach/features/shop/domain/entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<void> addCartItem(CartItemEntity item);
  Future<void> updateCartItem(CartItemEntity item);
  Future<void> deleteCartItem(String itemId);
  Future<CartItemEntity?> getCartItemByUserIdAndProductId(String userId, String productId);
  Future<void> updateCartItemQuantityByIdAndUserId(String productId, String userId, int newQuantity);
  Future<void> removeCartItemByIdAndUserId(String productId, String userId);
  Future<List<CartItemEntity>> getCartItemsByUserId(String userId);
  Future<void> clearCartByUserIdAndProductId(String userId);
}
