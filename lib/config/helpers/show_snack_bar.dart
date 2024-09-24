import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(content: Text(message))
  );
}

void showSnackBarWhitAction(BuildContext context, {required String message, String label = 'OK', required VoidCallback onPressed}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(days: 1),
      content: Text(message),
      action: SnackBarAction(
        label: label,
        onPressed: () {
          onPressed();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}