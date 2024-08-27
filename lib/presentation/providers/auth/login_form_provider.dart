import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:rieu/infrastructure/inputs/inputs.dart';

class LoginFormProvider extends ChangeNotifier {
  bool isPosting = false;
  bool isFormPosted = false;
  bool isValid = false;
  Email email = const Email.pure();
  Password password = const Password.pure();
  final Function(String email, String password) loginUserCallback;

  LoginFormProvider({required this.loginUserCallback});

  void onEmailChange(String value) {
    email = Email.dirty(value: value);
    isValid = Formz.validate([email, password]);
    notifyListeners();
  }

  void onPasswordChange(String value) {
    password = Password.dirty(value: value);
    isValid = Formz.validate([email, password]);
    notifyListeners();
  }

  Future<void> onFormSubmit() async {
    _touchEveryField();
    if (!isValid) return;

    isPosting = true;
    notifyListeners();
    
    await loginUserCallback(email.value, password.value);
    
    isPosting = false;
    notifyListeners();
  }

  void _touchEveryField() {
    email = Email.dirty(value: email.value);
    password = Password.dirty(value: password.value);
    isFormPosted = true;
    isValid = Formz.validate([email, password]);
    notifyListeners();
  }

  @override
  String toString() {
    return '''
    LoginFormProvider:
      isPosting: $isPosting,
      isValid: $isValid,
      email: $email,
      password: $password
    ''';
  }
}