import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/repositories/home_recipe_repository.dart';

class DeleteHomeRecipeUseCase {
  final HomeRecipeRepository repository;

  DeleteHomeRecipeUseCase(this.repository);

  Future<Either<Failure, void>> execute(String recipeId) {
    return repository.deleteHomeRecipe(recipeId);
  }
}
