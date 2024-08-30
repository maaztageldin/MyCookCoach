import 'package:equatable/equatable.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/favorite_entity.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<FavoriteEntity> favorites;

  const FavoriteLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object> get props => [message];
}

class FavoriteAdded extends FavoriteState {
  final FavoriteEntity favorite;

  const FavoriteAdded(this.favorite);

  @override
  List<Object> get props => [favorite];
}

class FavoriteRemoved extends FavoriteState {
  final String recipeId;
  final String userId;

  const FavoriteRemoved(this.recipeId, this.userId);

  @override
  List<Object> get props => [recipeId, userId];
}
