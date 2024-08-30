import 'package:mycookcoach/features/shop/domain/entities/cart_item_entity.dart';
import 'package:mycookcoach/features/shop/domain/repositories/cart_repository.dart';

class AddCartItemUseCase {
  final CartRepository repository;

  AddCartItemUseCase({required this.repository});

  Future<void> call(CartItemEntity item) async {
    return await repository.addCartItem(item);
  }
}
