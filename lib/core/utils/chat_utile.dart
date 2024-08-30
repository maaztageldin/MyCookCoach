import 'package:flutter/material.dart';
import 'package:mycookcoach/core/services/database_service.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/pages/chat/chat_page.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';

class ChatUtils {
  final DataBaseService _dataBaseService = DataBaseService();

  Future<void> startChat(BuildContext context, String currentUserId, String otherUserId, String recipeId) async {
    try {
      final chatExists = await _dataBaseService.checkChatExists(
        currentUserId,
        otherUserId,
        recipeId,
      );
      final UserEntity? currentUser = await _dataBaseService.getUserById(currentUserId);
      final UserEntity? otherUser = await _dataBaseService.getUserById(otherUserId);

      if (currentUser == null || otherUser == null) {
        throw Exception("User not found");
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            chatUserId: otherUserId,
            currentUserEntity: currentUser,
            otherUserEntity: otherUser,
            recipeId: recipeId,
          ),
        ),
      );

      if (!chatExists) {
        await _dataBaseService.createNewChat(
          currentUserId,
          otherUserId,
          recipeId,
        );
      }
    } catch (e) {
      // Handle exceptions (optional)
      debugPrint('Error starting chat: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start chat: $e')),
      );
    }
  }
}
