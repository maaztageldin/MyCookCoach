import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';

abstract class KitchenItemRepository {
  Future<List<KitchenItemEntity>> fetchKitchenItems();
  Future<void> addKitchenItem(KitchenItemEntity item);
  Future<void> updateKitchenItem(KitchenItemEntity item);
  Future<void> deleteKitchenItem(String itemId);
}
