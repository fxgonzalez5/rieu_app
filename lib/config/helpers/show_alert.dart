import 'package:flutter/material.dart';

void showAlert(BuildContext context, String title, message, {Function()? onContinue}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
          ),
          onPressed: onContinue,
          child: const Text('Continuar'),
        ),
      ],
    ),
  );
}