import 'package:mycookcoach/features/shop/domain/repositories/kitchen_item_repository.dart';

class DeleteKitchenItemUseCase {
  final KitchenItemRepository repository;

  DeleteKitchenItemUseCase({required this.repository});

  Future<void> call(String itemId) async {
    return await repository.deleteKitchenItem(itemId);
  }
}
