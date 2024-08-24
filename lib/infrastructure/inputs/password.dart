import 'package:formz/formz.dart';

// Define input validation errors
enum PasswordError { empty, length, format, mismatch }

// Extend FormzInput and provide the input type and error type.
class Password extends FormzInput<String, PasswordError> {
  static final RegExp passwordRegExp = RegExp(
    r'(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$',
  );
  final String? confirmPassword;

  // Call super.pure to represent an unmodified form input.
  const Password.pure({this.confirmPassword}) : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Password.dirty({String value = '', this.confirmPassword}) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PasswordError.empty) return 'El campo es requerido';
    if (displayError == PasswordError.length) return 'Mínimo 6 caracteres';
    if (displayError == PasswordError.format) return 'Debe de tener letras, al menos una mayúscula y un número';
    if (displayError == PasswordError.mismatch) return 'Las contraseñas no coinciden';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  PasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return PasswordError.empty;
    if (value.length < 6) return PasswordError.length;
    if (!passwordRegExp.hasMatch(value)) return PasswordError.format;
    if (confirmPassword != null && confirmPassword != value) return PasswordError.mismatch;

    return null;
  }
}