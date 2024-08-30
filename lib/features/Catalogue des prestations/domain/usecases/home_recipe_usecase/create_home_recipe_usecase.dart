import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/home_recipe_entity.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/repositories/home_recipe_repository.dart';

class CreateHomeRecipeUseCase {
  final HomeRecipeRepository repository;

  CreateHomeRecipeUseCase(this.repository);

  Future<Either<Failure, void>> execute(HomeRecipeEntity recipe) {
    return repository.createHomeRecipe(recipe);
  }
}
