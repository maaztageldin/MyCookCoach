import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/repositories/favorite_repository.dart';

class RemoveFavoriteUseCase {
  final FavoriteRepository repository;

  RemoveFavoriteUseCase(this.repository);

  Future<void> call(String userId, String recipeId) {
    return repository.removeFavorite(userId, recipeId);
  }
}