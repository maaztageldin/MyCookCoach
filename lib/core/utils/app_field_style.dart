import 'package:flutter/material.dart';

class AppButtonStyles {
  static ButtonStyle primaryButtonStyle(BuildContext context) {
    return TextButton.styleFrom(
      elevation: 3.0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
