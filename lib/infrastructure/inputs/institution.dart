import 'package:formz/formz.dart';

// Define input validation errors
enum InstitutionError { empty, length }

// Extend FormzInput and provide the input type and error type.
class Institution extends FormzInput<String, InstitutionError> {
  // Call super.pure to represent an unmodified form input.
  const Institution.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Institution.dirty({String value = ''}) : super.dirty(value);

  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == InstitutionError.empty ) return 'El campo es requerido';
    if ( displayError == InstitutionError.length ) return 'Mínimo 15 caracteres';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  InstitutionError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return InstitutionError.empty;
    if ( value.length < 15 ) return InstitutionError.length;

    return null;
  }
}