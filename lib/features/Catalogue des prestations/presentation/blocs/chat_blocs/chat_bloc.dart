import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:mycookcoach/core/errors/failure.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/data/models/chat.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/usecases/chat_usecases/get_chat_list_by_recipe_and_chef_usecase.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/chat_blocs/chat_event.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/blocs/chat_blocs/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatListByRecipeAndChefUseCase getChatListByRecipeAndChefUseCase;

  ChatBloc({required this.getChatListByRecipeAndChefUseCase})
      : super(ChatInitial()) {
    on<GetChatListByRecipeIDandChefID>(_onGetChatListByRecipeIDandChefID);
  }

  Future<void> _onGetChatListByRecipeIDandChefID(
      GetChatListByRecipeIDandChefID event, Emitter<ChatState> emit) async {
    emit(ChatLoading());

    final Either<Failure, List<Chat>> result =
        await getChatListByRecipeAndChefUseCase(
      recipeID: event.recipeID,
      chefID: event.chefID,
    );

    result.fold(
      (failure) => emit(ChatErrorState(_mapFailureToMessage(failure))),
      (chats) => emit(ChatListLoaded(chats)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case FireBaseFailure:
        return (failure as FireBaseFailure).message;
      default:
        return 'Unexpected error';
    }
  }
}
