import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadUserPfp(
      {required File file, required String uid}) async {
    try {
      Reference fileRef = _firebaseStorage
          .ref('users/pfps')
          .child('$uid${file.path.split('.').last}');

      UploadTask task = fileRef.putFile(file);
      return await task.then((p) async {
        if (p.state == TaskState.success) {
          return await fileRef.getDownloadURL();
        }
        return null;
      });
    } catch (e) {
      print('Erreur lors du téléchargement de la photo de profil: $e');
      return null;
    }
  }

  Future<String?> uploadImageToChat({
    required File file,
    required String chatID,
  }) async {
    try {
      Reference fileRef = _firebaseStorage.ref('chats/$chatID').child(
          '${DateTime.now().toIso8601String()}.${file.path.split('.').last}');

      UploadTask task = fileRef.putFile(file);
      return await task.then((p) async {
        if (p.state == TaskState.success) {
          return await fileRef.getDownloadURL();
        }
        return null;
      });
    } catch (e) {
      print('Erreur lors du téléchargement de l\'image du chat: $e');
      return null;
    }
  }
}
