import 'package:equatable/equatable.dart';
import 'package:mycookcoach/features/shop/domain/entities/cart_item_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class FetchCartItemsEvent extends CartEvent {}

class AddCartItemEvent extends CartEvent {
  final CartItemEntity item;

  const AddCartItemEvent({required this.item});

  @override
  List<Object> get props => [item];
}

class UpdateCartItemEvent extends CartEvent {
  final CartItemEntity item;

  const UpdateCartItemEvent({required this.item});

  @override
  List<Object> get props => [item];
}

class DeleteCartItemEvent extends CartEvent {
  final String itemId;

  const DeleteCartItemEvent({required this.itemId});

  @override
  List<Object> get props => [itemId];
}

class RecalculateTotalEvent extends CartEvent {
  final int quantity;
  final String productId;

  RecalculateTotalEvent(this.quantity, this.productId);

  @override
  List<Object> get props => [quantity, productId];
}

class GetCartItemByUserIdAndProductIdEvent extends CartEvent {
  final String userId;
  final String productId;

  GetCartItemByUserIdAndProductIdEvent({required this.userId, required this.productId});
}
