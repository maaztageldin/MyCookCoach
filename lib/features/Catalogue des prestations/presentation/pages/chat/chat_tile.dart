import 'package:flutter/material.dart';
import 'package:mycookcoach/core/services/database_service.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';

class ChatTile extends StatelessWidget {
  final String userId;
  final VoidCallback onTap;

  const ChatTile({required this.userId, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final DataBaseService _dataBaseService = DataBaseService();

    return FutureBuilder<UserEntity?>(
      future: _dataBaseService.getUserById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            title: Text('Loading...'),
          );
        } else if (snapshot.hasError) {
          return ListTile(
            title: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const ListTile(
            title: Text('User not found'),
          );
        } else {
          final user = snapshot.data!;
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.pictureUrl ?? ''),
            ),
            title: Text(user.firstName ?? 'Unknown User'),
            subtitle: Text(user.lastName ?? ''),
            onTap: onTap,
          );
        }
      },
    );
  }
}
