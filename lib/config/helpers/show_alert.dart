import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rieu/config/theme/responsive.dart';

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

void showRatingDialog(BuildContext context, {double? initialRating, ValueChanged<double>? onRatingUpdate}) {
  final responsive = Responsive(context);
  final texts = Theme.of(context).textTheme;
  double rating = 0;

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) => AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      title: const Text('¿Qué te ha parecido el curso/evento?'),
      titleTextStyle: texts.titleLarge,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RatingBar.builder(
            allowHalfRating: true,
            itemSize: responsive.ip(3.5),
            initialRating: initialRating ?? 0,
            itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
            ),
            onRatingUpdate: (value) {
              rating = value;
            },
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            onRatingUpdate?.call(rating);
            Navigator.of(context).pop();
          },
          child: const Text('Enviar'),
        ),
      ],
    ),
  );
}