import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycookcoach/core/utils/dialog_helper.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_bloc.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/user/user_event.dart';
import 'package:permission_handler/permission_handler.dart';

class EditPersonalInfo extends StatefulWidget {
  final UserEntity user;

  const EditPersonalInfo({super.key, required this.user});

  @override
  _EditPersonalInfoState createState() => _EditPersonalInfoState();
}

class _EditPersonalInfoState extends State<EditPersonalInfo> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _birthDateController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String _userImgUrl = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _birthDateController = TextEditingController(text: widget.user.birthDate);

    _userImgUrl = widget.user.pictureUrl!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf8f8f8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          _getImageProvider(widget.user.pictureUrl),
                    ),
                    Positioned(
                      bottom: -12,
                      right: -10,
                      child: IconButton(
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.blue,
                          size: 20,
                        ),
                        onPressed: pickLogo,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                buildEditableField(
                  controller: _firstNameController,
                  label: 'Prénom',
                  validator: validateName,
                ),
                const SizedBox(height: 20),
                buildEditableField(
                  controller: _lastNameController,
                  label: 'Nom de famille',
                  validator: validateName,
                ),
                const SizedBox(height: 20),
                buildEditableField(
                  controller: _birthDateController,
                  label: 'Date de naissance',
                  keyboardType: TextInputType.datetime,
                  validator: validateBirthDate,
                ),
                const SizedBox(height: 50),
                CustomButton(
                  text: 'Mettre à jour',
                  onPressed: () async {
                    if (kDebugMode) {
                      print("55555555555555555555");
                    }
                    if (_formKey.currentState?.validate() == true) {
                      if (_imageFile != null) {
                        if (kDebugMode) {
                          print("666666666666666666666");
                        }
                        _userImgUrl =/* simpleUpload(); */await _uploadLogoToFirebase(_imageFile!);
                        if (kDebugMode) {
                          print("4444444444444444444444444444444");
                          print(_userImgUrl);
                        }
                      }

                      final updatedUser = widget.user.copyWith(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        birthDate: _birthDateController.text,
                        pictureUrl: _userImgUrl,
                      );

                      context.read<UserBloc>().add(UpdateUser(updatedUser));
                    }
                  },
                  buttonColor: Color(0xFF8B4513).withOpacity(0.8),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pickLogo() async {
    final status = await Permission.storage.status;

    if (status.isGranted) {
      _pickImage();
    } else if (status.isPermanentlyDenied) {
      DialogHelper.showPermissionDeniedDialog(context);
    } else {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        _pickImage();
      } else if (result.isPermanentlyDenied) {
        DialogHelper.showPermissionDeniedDialog(context);
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _userImgUrl = pickedFile.path;
      });
    } else {
      DialogHelper.showUserCancelledDialog(context);
    }
  }

  Future<String> _uploadLogoToFirebase(File file) async {
    if (!file.existsSync()) {
      print("Error: File does not exist at path: ${file.path}");
    }
    if (_userImgUrl.isNotEmpty &&
        (_userImgUrl.startsWith('gs://') ||
            _userImgUrl.startsWith('https://'))) {
      try {
        final oldRef = FirebaseStorage.instance.refFromURL(_userImgUrl);

        await oldRef.getDownloadURL();
        await oldRef.delete();
      } catch (e) {
        if (e is FirebaseException && e.code == 'object-not-found') {
          print("Object not found at URL: $_userImgUrl");
        } else {
          print("Error deleting old logo: $e");
        }
      }
    } else if (_userImgUrl.isNotEmpty) {
      print("Invalid URL: $_userImgUrl");
    }

    final ref = FirebaseStorage.instance.ref().child(
        'user_profile_image/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');

    try {
      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});

      final newUrl = await snapshot.ref.getDownloadURL();
      return newUrl;
    } catch (e) {
      print("Error uploading file: $e");
      throw e;
    }
  }

  Future<void> simpleUpload() async {
    File file = File('path_to_some_file');
    if (!file.existsSync()) {
      print("Error: File does not exist at path: ${file.path}");
      return;
    }
    try {
      final ref = FirebaseStorage.instance.ref().child('test_upload/file.txt');
      await ref.putFile(file);
      print('Upload successful');
    } catch (e) {
      print('Error during upload: $e');
    }
  }


  ImageProvider _getImageProvider(String? imageUrl) {
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      if (Uri.tryParse(imageUrl)!.isAbsolute) {
        return NetworkImage(imageUrl);
      } else {
        return FileImage(File(imageUrl));
      }
    } else {
      return const AssetImage('assets/img/img.png');
    }
  }

  Widget buildEditableField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      style: const TextStyle(color: Colors.black87),
      validator: validator,
    );
  }

  String? validateBirthDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer une date de naissance.';
    }

    final dateRegExp =
        RegExp(r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$');
    if (!dateRegExp.hasMatch(value)) {
      return 'Format de date invalide. Utilisez le format dd/mm/yyyy.';
    }

    final dateParts = value.split('/');
    final day = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final year = int.parse(dateParts[2]);

    try {
      final birthDate = DateTime(year, month, day);

      final now = DateTime.now();
      final minDate = DateTime(now.year - 16, now.month, now.day);

      if (birthDate.isAfter(minDate)) {
        return "Vous devez avoir au moins 16 ans.";
      }
    } catch (e) {
      return 'Date de naissance invalide.';
    }

    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer un nom de famille ou un prénom.';
    }

    int spaceCount = ' '.allMatches(value).length;
    if (spaceCount > 4) {
      return 'Le nom ou prénom ne doit pas contenir plus de 4 espaces.';
    }

    String trimmedValue = value.replaceAll(' ', '');

    if (trimmedValue.length < 2 || trimmedValue.length > 16) {
      return 'Le nom ou prénom doit contenir entre 2 et 16 lettres.';
    }

    final nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegExp.hasMatch(value)) {
      return 'Le nom ou prénom ne doit contenir que des lettres et des espaces.';
    }

    return null;
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}
