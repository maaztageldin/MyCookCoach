import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/core/utils/type_def.dart';

import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/home_recipe_entity.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/repositories/home_recipe_repository.dart';

class HomeRecipeRepositoryImpl implements HomeRecipeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  ResultFuture<HomeRecipeEntity> getHomeRecipeById(String recipeId) async {
    try {
      final doc = await _firestore.collection('recipes').doc(recipeId).get();
      if (doc.exists && doc.data() != null) {
        return Right(
          HomeRecipeEntity.fromDocument(doc.data() as Map<String, dynamic>),
        );
      } else {
        return Left(FireBaseFailure(
            message: 'No recipe found with ID: $recipeId', statusCode: 404));
      }
    } catch (e) {
      if (e is FirebaseException) {
        return Left(FireBaseFailure(
            message: e.message ?? "Failed to fetch recipe: ${e.toString()}",
            statusCode: 500));
      } else {
        return Left(FireBaseFailure(
            message: "Failed to get recipe with this ID: ${e.toString()}",
            statusCode: 500));
      }
    }
  }

  @override
  ResultFuture<void> createHomeRecipe(HomeRecipeEntity recipe) async {
    try {
      final recipesCollection = _firestore.collection('recipes');
      await recipesCollection.doc(recipe.name).set(recipe.toDocument());
      return const Right(null);
    } catch (e) {
      if (e is FirebaseException) {
        return Left(FireBaseFailure(
            message: e.message ?? "Failed to create recipe: ${e.toString()}",
            statusCode: 500));
      } else {
        return Left(FireBaseFailure(
            message: "Failed to create recipe: ${e.toString()}",
            statusCode: 500));
      }
    }
  }

  @override
  ResultVoid updateHomeRecipe(HomeRecipeEntity recipe) async {
    try {
      await _firestore
          .collection('recipes')
          .doc(recipe.name)
          .update(recipe.toDocument());
      return const Right(null);
    } catch (e) {
      if (e is FirebaseException) {
        return Left(FireBaseFailure(
            message: e.message ?? "Failed to update recipe: ${e.toString()}",
            statusCode: 500));
      } else {
        return Left(FireBaseFailure(
            message: "Failed to update recipe: ${e.toString()}",
            statusCode: 500));
      }
    }
  }

  @override
  ResultVoid deleteHomeRecipe(String recipeId) async {
    try {
      await _firestore.collection('recipes').doc(recipeId).delete();
      return const Right(null);
    } catch (e) {
      if (e is FirebaseException) {
        return Left(FireBaseFailure(
            message: e.message ?? "Failed to delete recipe: ${e.toString()}",
            statusCode: 500));
      } else {
        return Left(FireBaseFailure(
            message: "Failed to delete recipe: ${e.toString()}",
            statusCode: 500));
      }
    }
  }

  @override
  ResultFuture<List<HomeRecipeEntity>> fetchAllHomeRecipes() async {
    try {
      final snapshot = await _firestore.collection('home_recipes').get();
      final recipes = snapshot.docs
          .map((doc) => HomeRecipeEntity.fromDocument(doc.data()))
          .toList();
      return Right(recipes);
    } catch (e) {
      if (e is FirebaseException) {
        return Left(FireBaseFailure(
            message: e.message ?? "An unknown error occurred with Firebase",
            statusCode: 500));
      } else {
        return Left(FireBaseFailure(
            message: "Failed to fetch recipes: ${e.toString()}",
            statusCode: 500));
      }
    }
  }
}
