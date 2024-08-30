import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/favorite_entity.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/repositories/favorite_repository.dart';

class AddFavoriteUseCase {
  final FavoriteRepository repository;

  AddFavoriteUseCase(this.repository);

  Future<void> call(FavoriteEntity favorite) {
    return repository.addFavorite(favorite);
  }
}
