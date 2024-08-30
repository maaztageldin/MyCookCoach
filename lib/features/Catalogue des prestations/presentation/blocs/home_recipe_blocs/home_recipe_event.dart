import 'package:equatable/equatable.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/home_recipe_entity.dart';

abstract class HomeRecipeEvent extends Equatable {
  const HomeRecipeEvent();

  @override
  List<Object> get props => [];
}

class GetHomeRecipeById extends HomeRecipeEvent {
  final String recipeId;

  const GetHomeRecipeById(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}

class CreateHomeRecipe extends HomeRecipeEvent {
  final HomeRecipeEntity recipe;

  const CreateHomeRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class UpdateHomeRecipe extends HomeRecipeEvent {
  final HomeRecipeEntity recipe;

  const UpdateHomeRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class DeleteHomeRecipe extends HomeRecipeEvent {
  final String recipeId;

  const DeleteHomeRecipe(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}

class FetchAllHomeRecipes extends HomeRecipeEvent {}
