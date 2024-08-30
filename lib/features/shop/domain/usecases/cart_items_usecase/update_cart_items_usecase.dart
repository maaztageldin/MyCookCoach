import 'package:mycookcoach/features/shop/domain/entities/cart_item_entity.dart';
import 'package:mycookcoach/features/shop/domain/repositories/cart_repository.dart';

class UpdateCartItemUseCase {
  final CartRepository repository;

  UpdateCartItemUseCase({required this.repository});

  Future<void> call(CartItemEntity item) async {
    return await repository.updateCartItem(item);
  }
}
