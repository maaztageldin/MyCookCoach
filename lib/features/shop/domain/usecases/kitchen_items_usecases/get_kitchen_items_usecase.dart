import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';
import 'package:mycookcoach/features/shop/domain/repositories/kitchen_item_repository.dart';

class GetKitchenItemsUseCase {
  final KitchenItemRepository repository;

  GetKitchenItemsUseCase({required this.repository});

  Future<List<KitchenItemEntity>> call() async {
    return await repository.fetchKitchenItems();
  }
}
