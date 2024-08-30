import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/data/models/chat.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<Chat>>> fetchChatsByRecipeAndChef(String recipeId, String chefId) async {
    try {
      final querySnapshot = await _firestore
          .collection('chats')
          .where('recipe_id', isEqualTo: recipeId)
          //.where('chef_id', isEqualTo: chefId)
          .get();

      final List<Chat> chats = querySnapshot.docs
          .map((doc) => Chat.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return Right(chats);
    } catch (e) {
      if (e is FirebaseException) {
        return Left(FireBaseFailure(
            message: e.message ?? "Failed to fetch chats: ${e.toString()}",
            statusCode: 500));
      } else {
        return Left(FireBaseFailure(
            message: "Failed to fetch chats: ${e.toString()}",
            statusCode: 500));
      }
    }
  }
}
