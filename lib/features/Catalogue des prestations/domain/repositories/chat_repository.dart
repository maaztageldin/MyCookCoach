import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/data/models/chat.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Chat>>> fetchChatsByRecipeAndChef(String recipeId, String chefId);
}
