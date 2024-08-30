import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/message_entity.dart';

class ChatEntity {
  final String id;
  final String recipeId;
  final List<String> participants;
  final List<MessageEntity> messages;

  ChatEntity({
    required this.id,
    required this.participants,
    required this.messages,
    required this.recipeId,
  });
}
