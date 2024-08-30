import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class AddFavorite extends FavoriteEvent {
  final String recipeId;
  final String type;
  final String userId;

  const AddFavorite(this.recipeId, this.type, this.userId);

  @override
  List<Object> get props => [recipeId, type, userId];

}

class RemoveFavorite extends FavoriteEvent {
  final String recipeId;
  final String userId;

  const RemoveFavorite(this.recipeId, this.userId);

  @override
  List<Object> get props => [recipeId, userId];
}

class GetFavorites extends FavoriteEvent {
  final String userId;

  const GetFavorites(this.userId);

  @override
  List<Object> get props => [userId];
}
