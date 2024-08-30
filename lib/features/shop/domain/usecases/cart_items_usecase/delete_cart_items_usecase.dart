
import 'package:mycookcoach/features/shop/domain/repositories/cart_repository.dart';

class DeleteCartItemUseCase {
  final CartRepository repository;

  DeleteCartItemUseCase({required this.repository});

  Future<void> call(String itemId) async {
    return await repository.deleteCartItem(itemId);
  }
}
