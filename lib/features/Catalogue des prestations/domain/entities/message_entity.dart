class MessageEntity {
  final String senderID;
  final String content;
  final MessageType messageType;
  final DateTime sentAt;

  MessageEntity({
    required this.senderID,
    required this.content,
    required this.messageType,
    required this.sentAt,
  });
}

enum MessageType {
  Text,
  Image,
}
