import 'package:mycookcoach/core/utils/type_def.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/favorite_entity.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/repositories/favorite_repository.dart';

class GetFavoritesUseCase {
  final FavoriteRepository repository;

  GetFavoritesUseCase(this.repository);

  ResultFuture<List<FavoriteEntity>> call(String userId) {
    return repository.getFavorites(userId);
  }
}
