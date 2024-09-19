import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycookcoach/features/authentication/presentation/pages/profile/profile_screen.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.name,
    required this.role,
    this.photoUrl,
  });

  final String name, role;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white24,
        backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
            ? NetworkImage(photoUrl!)
            : null,
        child: photoUrl == null || photoUrl!.isEmpty
            ? const Icon(
          CupertinoIcons.person,
          color: Colors.white,
        )
            : null,
      ),
      title: Text(
        name,
        style: TextStyle(color: Colors.white,),
      ),
      subtitle: Text(
        role,
        style: TextStyle(color: Colors.white,),
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
