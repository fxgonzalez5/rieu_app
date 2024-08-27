import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final String label, hint;
  final String? errorMessage;
  final bool noVisibility;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    required this.label,
    required this.hint,
    this.errorMessage,
    this.noVisibility = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    final texts = Theme.of(context).textTheme;

    return TextFormField(
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      style: texts.bodyLarge,
      obscureText: noVisibility,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorMessage,
      ),
    );
  }
}