import 'package:equatable/equatable.dart';
import 'package:mycookcoach/features/shop/domain/entities/cart_item_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class FetchCartItemsByUserIdEvent extends CartEvent {
  final String userId;

  const FetchCartItemsByUserIdEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

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
  final String userId;

  const DeleteCartItemEvent({required this.itemId, required this.userId});

  @override
  List<Object> get props => [itemId, userId];
}

class RecalculateTotalEvent extends CartEvent {
  final int quantity;
  final String productId;
  final String userId;

  RecalculateTotalEvent(this.quantity, this.productId, this.userId);

  @override
  List<Object> get props => [quantity, productId, userId];
}

class GetCartItemByUserIdAndProductIdEvent extends CartEvent {
  final String userId;
  final String productId;

  GetCartItemByUserIdAndProductIdEvent({required this.userId, required this.productId});
}

class UpdateCartItemQuantityByIdAndUserIdEvent extends CartEvent {
  final String productId;
  final String userId;
  final int newQuantity;

  UpdateCartItemQuantityByIdAndUserIdEvent({
    required this.productId,
    required this.userId,
    required this.newQuantity,
  });
}

class RemoveCartItemByIdAndUserIdEvent extends CartEvent {
  final String productId;
  final String userId;

  RemoveCartItemByIdAndUserIdEvent({
    required this.productId,
    required this.userId,
  });
}

class ClearCartByUserIdAndProductIdEvent extends CartEvent {
  final String userId;

  ClearCartByUserIdAndProductIdEvent({required this.userId});
}
