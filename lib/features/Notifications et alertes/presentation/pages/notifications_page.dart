import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String description;
  final DateTime date;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.description,
    required this.date,
    this.isRead = false,
  });
}

class NotificationsPage extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Nouvelle commande',
      description: 'Vous avez reçu une nouvelle commande.',
      date: DateTime.now(),
    ),
    NotificationItem(
      title: 'Mise à jour de l\'application',
      description: 'Une nouvelle version de l\'application est disponible.',
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    // Ajoutez d'autres notifications ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: Icon(
              notification.isRead
                  ? Icons.notifications
                  : Icons.notifications_active,
              color: notification.isRead ? Colors.grey : Colors.blue,
            ),
            title: Text(notification.title),
            subtitle: Text(notification.description),
            trailing: Text(
              _formatDate(notification.date),
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            onTap: () {
              // Logique lorsque la notification est cliquée
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
