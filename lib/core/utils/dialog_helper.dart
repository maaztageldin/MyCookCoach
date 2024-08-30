import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class DialogHelper {
  static void showPermissionRequestDialog(BuildContext context, Function onPermissionGranted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Autorisation requise'),
          content: Text(
              'Cette application doit accéder à vos photos pour choisir un logo. Veuillez permettre l’accès pour continuer.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                var status = await Permission.photos.request();
                if (status.isGranted) {
                  onPermissionGranted();
                } else {
                  showPermissionDeniedDialog(context);
                }
              },
              child: Text('Autoriser'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  static void videoShowPermissionRequestDialog(BuildContext context, Function onPermissionGranted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('autorisation requise'),
          content: Text('Cette application a besoin d’accéder à votre stockage pour choisir des vidéos. S’il vous plaît accorder l’accès pour continuer.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                var status = await Permission.storage.request();
                if (status.isGranted) {
                  onPermissionGranted();
                } else {
                  showPermissionDeniedDialog(context);
                }
              },
              child: Text('autoriser'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('annuler'),
            ),
          ],
        );
      },
    );
  }

  static void showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Autorisation refusée'),
          content: Text(
              'Une autorisation de stockage est requise pour choisir un logo. Veuillez l’activer dans les paramètres.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showUserCancelledDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sélecteur annulé'),
          content: Text(
              'Vous avez annulé le sélecteur. Veuillez choisir un logo pour continuer.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
