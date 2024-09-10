import 'package:mycookcoach/features/shop/domain/entities/order_entity.dart';

abstract class PurchaseState {}

class PurchaseInitial extends PurchaseState {}

class PurchaseLoading extends PurchaseState {}

class PurchaseSuccess extends PurchaseState {}

class PurchaseFailure extends PurchaseState {
  final String error;

  PurchaseFailure(this.error);
}

class OrdersLoaded extends PurchaseState {
  final List<OrderEntity> items;

  OrdersLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

/*
*
* class KitchenItemLoadedState extends KitchenItemState {
  final List<KitchenItemEntity> items;

  const KitchenItemLoadedState({required this.items});

  @override
  List<Object?> get props => [items];
}
* */