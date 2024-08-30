import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';
import 'package:mycookcoach/features/shop/domain/repositories/kitchen_item_repository.dart';

class UpdateKitchenItemUseCase {
  final KitchenItemRepository repository;

  UpdateKitchenItemUseCase({required this.repository});

  Future<void> call(KitchenItemEntity item) async {
    return await repository.updateKitchenItem(item);
  }
}
