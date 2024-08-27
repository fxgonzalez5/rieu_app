import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:rieu/infrastructure/inputs/inputs.dart';

class RegisterFormProvider extends ChangeNotifier {
  bool isPosting = false;
  bool isFormPosted = false;
  bool isValid = false;
  Name name = const Name.pure();
  Email email = const Email.pure();
  Password password = const Password.pure();
  Password confirmPassword = const Password.pure();
  Institution institution = const Institution.pure();
  City city = const City.pure();
  final Function(String name, String email, String password, String institution, String city) registerUserCallback;

  RegisterFormProvider({required this.registerUserCallback});

  void onFullNameChange(String value) {
    name = Name.dirty(value: value);
    isValid = Formz.validate([name, email, password, confirmPassword, institution, city]);
    notifyListeners();
  }

  void onEmailChange(String value) {
    email = Email.dirty(value: value);
    isValid = Formz.validate([name, email, password, confirmPassword, institution, city]);
    notifyListeners();
  }

  void onPasswordChange(String value) {
    password = Password.dirty(value: value);
    isValid = Formz.validate([name, email, password, confirmPassword, institution, city]);
    notifyListeners();
  }

  void onConfirmPasswordChange(String value) {
    confirmPassword = Password.dirty(value: value, confirmPassword: password.value);
    isValid = Formz.validate([name, email, password, confirmPassword, institution, city]);
    notifyListeners();
  }

  void onInstitutionChange(String value) {
    institution = Institution.dirty(value: value);
    isValid = Formz.validate([name, email, password, confirmPassword, institution, city]);
    notifyListeners();
  }

  void onCityChange(String value) {
    city = City.dirty(value: value);
    isValid = Formz.validate([name, email, password, confirmPassword, institution, city]);
    notifyListeners();
  }

  void onFormSubmit() async {
    _touchEveryField();
    if (!isValid) return;

    isPosting = true;
    notifyListeners();
    
    await registerUserCallback(name.value, email.value, password.value, institution.value, city.value);
    
    isPosting = false;
    notifyListeners();
  }

  void _touchEveryField() {
    name = Name.dirty(value: name.value);
    email = Email.dirty(value: email.value);
    password = Password.dirty(value: password.value);
    confirmPassword = Password.dirty(value: confirmPassword.value, confirmPassword: password.value);
    institution = Institution.dirty(value: institution.value);
    city = City.dirty(value: city.value);

    isFormPosted = true;
    isValid = Formz.validate([name, email, password, confirmPassword, institution, city]);
    notifyListeners();
  }

  @override
  String toString() {
    return '''
    RegisterFormProvider:
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isValid: $isValid,
      fullName: $name,
      email: $email,
      password: $password,
      confirmPassword: $confirmPassword,
      institution: $institution,
      city: $city
    ''';
  }
}
