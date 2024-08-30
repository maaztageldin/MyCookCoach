import 'package:mycookcoach/core/utils/type_def.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/favorite_entity.dart';

abstract class FavoriteRepository {
  Future<void> addFavorite(FavoriteEntity favorite);
  ResultVoid removeFavorite(String userId, String recipeId);
  ResultFuture<List<FavoriteEntity>> getFavorites(String userId);
}