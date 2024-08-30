import 'package:mycookcoach/features/shop/domain/entities/cart_item_entity.dart';
import 'package:mycookcoach/features/shop/domain/repositories/cart_repository.dart';

class GetCartItemByUserIdAndProductIdUseCase {
  final CartRepository cartRepository;

  GetCartItemByUserIdAndProductIdUseCase({required this.cartRepository});

  Future<CartItemEntity?> call(String userId, String productId) async {
    return await cartRepository.getCartItemByUserIdAndProductId(userId, productId);
  }
}
