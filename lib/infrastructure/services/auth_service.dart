import 'package:rieu/domain/entities/entities.dart';

abstract class AuthService {
  Future<UserEntity> signInService();
  Future<void> signOutService();
}
