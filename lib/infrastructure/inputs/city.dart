import 'package:formz/formz.dart';

// Define input validation errors
enum CityError { empty, length }

// Extend FormzInput and provide the input type and error type.
class City extends FormzInput<String, CityError> {
  // Call super.pure to represent an unmodified form input.
  const City.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const City.dirty({String value = ''}) : super.dirty(value);

  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == CityError.empty ) return 'El campo es requerido';
    if ( displayError == CityError.length ) return 'Mínimo 4 caracteres';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  CityError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return CityError.empty;
    if ( value.length < 4 ) return CityError.length;

    return null;
  }
}