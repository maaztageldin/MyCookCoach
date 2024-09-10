import 'package:mycookcoach/features/shop/data/repositories/cart_repository_impl.dart';
import 'package:mycookcoach/features/shop/domain/repositories/cart_repository.dart';

class ClearCartUseCase {
  final CartRepository repository;

  ClearCartUseCase({required this.repository});

  Future<void> call(String userId) async {
    return await repository.clearCartByUserIdAndProductId(userId);
  }
}
