import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class GetChatListByRecipeIDandChefID extends ChatEvent {
  final String recipeID;
  final String chefID;

  const GetChatListByRecipeIDandChefID(this.recipeID, this.chefID);

  @override
  List<Object?> get props => [recipeID, chefID];
}
