import 'package:flutter/material.dart';

class InviteFriendsPage extends StatelessWidget {
  final List<Contact> contacts = [
    Contact(name: "Carla Schoen", phoneNumber: "207.555.0119", imageUrl: "https://via.placeholder.com/150"),
    Contact(name: "Esther Howard", phoneNumber: "702.555.0122", imageUrl: "https://via.placeholder.com/150"),
    Contact(name: "Robert Fox", phoneNumber: "239.555.0108", imageUrl: "https://via.placeholder.com/150"),
    Contact(name: "Jacob Jones", phoneNumber: "316.555.0116", imageUrl: "https://via.placeholder.com/150"),
    Contact(name: "Darlene Robertson", phoneNumber: "629.555.0129", imageUrl: "https://via.placeholder.com/150"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Friends'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(contact.imageUrl),
            ),
            title: Text(contact.name, style: TextStyle(fontSize: 16)),
            subtitle: Text(contact.phoneNumber, style: TextStyle(fontSize: 12)),
            trailing: ElevatedButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
              ),
              child: Text('Invite', style: TextStyle(color: Colors.white),),
            ),
          );
        },
      ),
    );
  }
}

class Contact {
  final String name;
  final String phoneNumber;
  final String imageUrl;

  Contact({
    required this.name,
    required this.phoneNumber,
    required this.imageUrl,
  });
}
