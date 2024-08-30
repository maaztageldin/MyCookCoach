import 'package:equatable/equatable.dart';
import 'package:mycookcoach/features/shop/domain/entities/kitchen_item_entity.dart';

abstract class KitchenItemState extends Equatable {
  const KitchenItemState();

  @override
  List<Object?> get props => [];
}

class KitchenItemLoadingState extends KitchenItemState {}

class KitchenItemLoadedState extends KitchenItemState {
  final List<KitchenItemEntity> items;

  const KitchenItemLoadedState({required this.items});

  @override
  List<Object?> get props => [items];
}

class KitchenItemErrorState extends KitchenItemState {
  final String message;

  const KitchenItemErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class KitchenItemSuccessState extends KitchenItemState {
  final String message;

  const KitchenItemSuccessState({required this.message});

  @override
  List<Object?> get props => [message];
}
