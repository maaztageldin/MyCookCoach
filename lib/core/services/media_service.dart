import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycookcoach/core/utils/dialog_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> getImageFromGallery(BuildContext context) async {
    final status = await Permission.storage.status;

    if (status.isGranted) {
      return await _pickImage(context);
    } else if (status.isPermanentlyDenied) {
      DialogHelper.showPermissionDeniedDialog(context);
      return null;
    } else {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        return await _pickImage(context);
      } else if (result.isPermanentlyDenied) {
        DialogHelper.showPermissionDeniedDialog(context);
        return null;
      } else {
        return null;
      }
    }
  }

  Future<File?> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      DialogHelper.showUserCancelledDialog(context);
      return null;
    }
  }
}
