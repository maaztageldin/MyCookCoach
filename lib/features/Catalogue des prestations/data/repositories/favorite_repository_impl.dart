import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/core/utils/type_def.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/favorite_entity.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/repositories/favorite_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  ResultFuture<void> addFavorite(FavoriteEntity favorite) async {
    try {
      await _firestore
          .collection('favorites')
          .doc(favorite.id)
          .set(favorite.toDocument());

      print("Favorite added: ${favorite.recipeId} for user ${favorite.userId}");
      return const Right(null);
    } catch (e) {
      print("Error adding favorite: ${e.toString()}");
      if (e is FirebaseException) {
        return Left(FireBaseFailure(
            message: e.message ?? "Failed to add favorite: ${e.toString()}",
            statusCode: 500));
      } else {
        return Left(FireBaseFailure(
            message: "Failed to add favorite: ${e.toString()}",
            statusCode: 500));
      }
    }
  }

  @override
  ResultVoid removeFavorite(String userId, String recipeId) async {
    try {
      QuerySnapshot favoriteSnapshot = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .where('recipeId', isEqualTo: recipeId)
          .get();

      if (favoriteSnapshot.docs.isNotEmpty) {
        await _firestore
            .collection('favorites')
            .doc(favoriteSnapshot.docs.first.id)
            .delete();
        print("Favorite removed: $recipeId for user $userId");
        return const Right(null);
      } else {
        print("Favorite not found for user: $userId and recipe: $recipeId");
        return const Right(null);
      }
    } catch (e) {
      print("Error removing favorite: ${e.toString()}");
      if (e is FirebaseException) {
        return Left(FireBaseFailure(
            message: e.message ?? "Failed to remove favorite: ${e.toString()}",
            statusCode: 500));
      } else {
        return Left(FireBaseFailure(
            message: "Failed to remove favorite: ${e.toString()}",
            statusCode: 500));
      }
    }
  }

  @override
  ResultFuture<List<FavoriteEntity>> getFavorites(String userId) async {
    try {
      QuerySnapshot favoritesSnapshot = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .get();

      List<FavoriteEntity> favorites = favoritesSnapshot.docs
          .map((doc) => FavoriteEntity.fromDocument(doc))
          .toList();

      print("Favorites fetched for user: $userId");
      return Right(favorites);
    } catch (e) {
      print("Error fetching favorites for user $userId: ${e.toString()}");
      if (e is FirebaseException) {
        return Left(FireBaseFailure(
            message: e.message ?? "Failed to fetch favorites: ${e.toString()}",
            statusCode: 500));
      } else {
        return Left(FireBaseFailure(
            message: "Failed to fetch favorites: ${e.toString()}",
            statusCode: 500));
      }
    }
  }
}
