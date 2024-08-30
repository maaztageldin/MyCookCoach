import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/data/models/chat.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/repositories/chat_repository.dart';

class GetChatListByRecipeAndChefUseCase {
  final ChatRepository repository;

  GetChatListByRecipeAndChefUseCase({required this.repository});

  Future<Either<Failure, List<Chat>>> call({
    required String recipeID,
    required String chefID,
  }) async {
    return await repository.fetchChatsByRecipeAndChef(recipeID, chefID);
  }
}
