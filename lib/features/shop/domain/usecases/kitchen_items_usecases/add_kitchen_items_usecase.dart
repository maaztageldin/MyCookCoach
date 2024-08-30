import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';
import 'package:mycookcoach/features/shop/domain/repositories/kitchen_item_repository.dart';

class AddKitchenItemUseCase {
  final KitchenItemRepository repository;

  AddKitchenItemUseCase({required this.repository});

  Future<void> call(KitchenItemEntity item) async {
    return await repository.addKitchenItem(item);
  }
}
