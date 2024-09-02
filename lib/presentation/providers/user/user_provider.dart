import 'package:flutter/widgets.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/domain/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository userRepository;
  UserEntity _user;

  UserProvider({
    required this.userRepository,
    required UserEntity user,
  }) : _user = user;

  UserEntity get user => _user;
  set user(UserEntity user) {
    _user = user;
    notifyListeners();
  }
}