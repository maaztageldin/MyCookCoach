import 'package:equatable/equatable.dart';
import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';

abstract class KitchenItemEvent extends Equatable {
  const KitchenItemEvent();

  @override
  List<Object?> get props => [];
}

class FetchKitchenItemsEvent extends KitchenItemEvent {}

class AddKitchenItemEvent extends KitchenItemEvent {
  final KitchenItemEntity item;

  const AddKitchenItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateKitchenItemEvent extends KitchenItemEvent {
  final KitchenItemEntity item;

  const UpdateKitchenItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class DeleteKitchenItemEvent extends KitchenItemEvent {
  final String itemId;

  const DeleteKitchenItemEvent(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class FetchKitchenItemsByCategoryEvent extends KitchenItemEvent {
  final int categoryIndex;

  FetchKitchenItemsByCategoryEvent({required this.categoryIndex});
}