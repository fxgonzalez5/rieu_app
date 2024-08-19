import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hint;
  final bool noVisibility;

  const CustomTextFormField({super.key, required this.label, required this.hint, this.noVisibility = false});

  @override
  Widget build(BuildContext context) {
    final texts = Theme.of(context).textTheme;

    return TextFormField(
      style: texts.bodyLarge,
      obscureText: noVisibility,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
    );
  }
}