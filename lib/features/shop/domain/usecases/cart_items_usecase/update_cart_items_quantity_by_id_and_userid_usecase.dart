import 'package:mycookcoach/features/shop/domain/entities/cart_item_entity.dart';
import 'package:mycookcoach/features/shop/domain/repositories/cart_repository.dart';

class UpdateCartItemQuantityByIdAndUserIdUseCase {
  final CartRepository repository;

  UpdateCartItemQuantityByIdAndUserIdUseCase({required this.repository});

  Future<void> call(String productId, String userId, int newQuantity)  async {
    return await repository.updateCartItemQuantityByIdAndUserId(productId, userId, newQuantity);
  }
}
