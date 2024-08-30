import 'package:mycookcoach/features/Catalogue%20des%20prestations/data/models/message.dart';

class Chat {
  String? id;
  String? recipeId;
  List<String>? participants;
  List<Message>? messages;

  Chat({
    required this.id,
    required this.recipeId,
    required this.participants,
    required this.messages,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    recipeId = json['recipe_id'];
    participants = List<String>.from(json['participants']);
    messages = (json['messages'] as List).map((m) => Message.fromJson(m)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['recipe_id'] = recipeId;
    data['participants'] = participants;
    data['messages'] = messages?.map((m) => m.toJson()).toList();
    return data;
  }
}
