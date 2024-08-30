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
      final docRef = _firestore
          .collection('favorites')
          .doc(favorite.userId)
          .collection('userFavorites')
          .doc(favorite.recipeId);

      await docRef.set(favorite.toDocument());
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
      final docRef = _firestore
          .collection('favorites')
          .doc(userId)
          .collection('userFavorites')
          .doc(recipeId);

      // Log pour vérifier si le document existe avant de le supprimer
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        await docRef.delete();
        print("Favorite removed: $recipeId for user $userId");
        return const Right(null);
      } else {
        print("Document not found: $recipeId for user $userId");
        return Left(FireBaseFailure(
            message: "Document not found: $recipeId for user $userId",
            statusCode: 404));
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
      final snapshot = await _firestore
          .collection('favorites')
          .doc(userId)
          .collection('userFavorites')
          .get();

      final favorites = snapshot.docs.map((doc) {
        return FavoriteEntity.fromDocument(doc.data() as Map<String, dynamic>);
      }).toList();

      print("Favorites fetched for user $userId: ${favorites.length}");
      return Right(favorites);
    } catch (e) {
      print("Error fetching favorites: ${e.toString()}");
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
