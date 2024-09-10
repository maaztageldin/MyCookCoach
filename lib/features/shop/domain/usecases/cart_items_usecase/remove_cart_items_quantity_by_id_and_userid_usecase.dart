import 'package:mycookcoach/features/shop/domain/repositories/cart_repository.dart';

class RemoveCartItemByIdAndUserIdUseCase {
  final CartRepository repository;

  RemoveCartItemByIdAndUserIdUseCase({required this.repository});

  Future<void> call(String productId, String userId) async {
    return await repository.removeCartItemByIdAndUserId(productId, userId);
  }
}
