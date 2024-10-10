import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/home_recipe_entity.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/repositories/home_recipe_repository.dart';

class GetHomeRecipesByIdsUseCase {
  final HomeRecipeRepository repository;

  GetHomeRecipesByIdsUseCase(this.repository);

  Future<Either<Failure, List<HomeRecipeEntity>>> execute(List<String> recipeIds) async {
    return await repository.getRecipesByIds(recipeIds);
  }
}
