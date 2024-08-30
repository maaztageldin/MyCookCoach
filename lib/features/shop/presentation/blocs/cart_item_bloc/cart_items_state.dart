import 'package:equatable/equatable.dart';
import 'package:mycookcoach/features/shop/domain/entities/cart_item_entity.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final List<CartItemEntity> items;

  const CartLoadedState({required this.items});

  @override
  List<Object> get props => [items];
}

class CartErrorState extends CartState {
  final String message;

  const CartErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class CartSuccessState extends CartState {
  final String message;

  const CartSuccessState({required this.message});

  @override
  List<Object> get props => [message];
}

class CartItemLoadedState extends CartState {
  final CartItemEntity item;

  const CartItemLoadedState({required this.item});

  @override
  List<Object> get props => [item];
}

class CartItemNotFoundState extends CartState {}
