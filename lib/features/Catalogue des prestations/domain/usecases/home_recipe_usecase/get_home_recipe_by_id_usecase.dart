import 'package:mycookcoach/core/errors/failure.dart';
import 'package:either_dart/either.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/home_recipe_entity.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/repositories/home_recipe_repository.dart';

class GetHomeRecipeByIdUseCase {
  final HomeRecipeRepository repository;

  GetHomeRecipeByIdUseCase(this.repository);

  Future<Either<Failure, HomeRecipeEntity>> execute(String recipeId) {
    return repository.getHomeRecipeById(recipeId);
  }
}
