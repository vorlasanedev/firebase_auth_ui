import 'package:flutter/material.dart';

class ShowMessage {
  void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Optional: Map raw error messages to friendly messages
  void showFriendlyError(BuildContext context, String error) {
    String friendlyMessage = _extractFriendlyMessage(error);
    showError(context, friendlyMessage);
  }

  String _extractFriendlyMessage(String error) {
    final lowerError = error.toLowerCase();

    if (lowerError.contains('wrong-password') ||
        lowerError.contains('invalid password')) {
      return 'Incorrect password.';
    } else if (lowerError.contains('no user record') ||
        lowerError.contains('user not found')) {
      return 'No account found with this email.';
    } else if (lowerError.contains('email-already-in-use') ||
        lowerError.contains('email exists')) {
      return 'This email is already registered.';
    } else if (lowerError.contains('network') ||
        lowerError.contains('offline')) {
      return 'No internet connection. Please try again.';
    }
    // Add more patterns as needed

    // Default message
    return 'An error occurred. Please try again.';
  }
}
