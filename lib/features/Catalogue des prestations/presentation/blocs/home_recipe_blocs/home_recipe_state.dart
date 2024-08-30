import 'package:equatable/equatable.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/home_recipe_entity.dart';

abstract class HomeRecipeState extends Equatable {
  const HomeRecipeState();

  @override
  List<Object> get props => [];
}

class HomeRecipeInitial extends HomeRecipeState {}

class HomeRecipeLoading extends HomeRecipeState {}

class HomeRecipeLoaded extends HomeRecipeState {
  final HomeRecipeEntity recipe;

  const HomeRecipeLoaded(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class HomeRecipesLoaded extends HomeRecipeState {
  final List<HomeRecipeEntity> desserts;
  final List<HomeRecipeEntity> plats;

  HomeRecipesLoaded({required this.desserts, required this.plats});
}


class HomeRecipeOperationSuccess extends HomeRecipeState {}

class HomeRecipeOperationFailure extends HomeRecipeState {
  final String error;

  const HomeRecipeOperationFailure(this.error);

  @override
  List<Object> get props => [error];
}
