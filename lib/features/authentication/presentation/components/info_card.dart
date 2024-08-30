import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycookcoach/features/authentication/presentation/pages/profile/profile_screen.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.name, required this.role});

  final String name, role;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.white24,
        child: Icon(
          CupertinoIcons.person,
          color: Colors.white,
        ),
      ),
      title: Text(
        name,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        role,
        style: TextStyle(color: Colors.white),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      },
    );
  }
}
