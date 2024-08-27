import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/infrastructure/services/services.dart';

abstract class AuthDataSource {
  Future<UserEntity?> checkAuthStatus();
  Future<UserEntity> register(String name, String email, String password, String institution, String city);
  Future<bool> verifyEmailAddress();
  Future<UserEntity> signInWithAService(AuthService authService);
  Future<UserEntity> login(String email, String password);
  Future<void> logout();
}
