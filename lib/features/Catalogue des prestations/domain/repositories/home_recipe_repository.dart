import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/home_recipe_entity.dart';
import 'package:either_dart/either.dart';

abstract class HomeRecipeRepository {
  Future<Either<Failure, HomeRecipeEntity>> getHomeRecipeById(String recipeId);
  Future<Either<Failure, void>> createHomeRecipe(HomeRecipeEntity recipe);
  Future<Either<Failure, void>> updateHomeRecipe(HomeRecipeEntity recipe);
  Future<Either<Failure, void>> deleteHomeRecipe(String recipeId);
  Future<Either<Failure, List<HomeRecipeEntity>>> fetchAllHomeRecipes();
  Future<Either<Failure, List<HomeRecipeEntity>>> getRecipesByIds(List<String> recipeIds);
}
