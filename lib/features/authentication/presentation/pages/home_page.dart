import 'package:flutter/material.dart';
import 'package:mycookcoach/features/authentication/presentation/pages/profile/profile_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Action pour l'icône de notification
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue sur l\'Accueil',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Sélectionnez une option ci-dessous :',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Action du bouton Profil
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: Text('Aller au Profil'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16), backgroundColor: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Action pour une autre fonctionnalité
              },
              child: Text('Autre Fonctionnalité'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16), backgroundColor: Colors.deepPurple,
              ),
            ),
            Spacer(),
            Center(
              child: Text(
                '© 2024 MonApplication',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
