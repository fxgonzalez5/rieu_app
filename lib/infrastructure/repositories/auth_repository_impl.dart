import 'package:rieu/domain/datasources/auth_datasource.dart';
import 'package:rieu/domain/entities/user_entity.dart';
import 'package:rieu/domain/repositories/auth_repository.dart';
import 'package:rieu/infrastructure/datasources/auth_datasource_impl.dart';
import 'package:rieu/infrastructure/services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource datasource;

  AuthRepositoryImpl({
    AuthDataSource? datasource
  }) : datasource = datasource ?? AuthDataSourceImpl();

  @override
  Stream<UserEntity?> checkAuthStatus() {
    return datasource.checkAuthStatus();
  }

  @override
  Future<UserEntity> register(String name, String email, String password, String institution, String city) {
    return datasource.register(name, email, password, institution, city);
  }

  @override
  Future<bool> verifyEmailAddress() {
    return datasource.verifyEmailAddress();
  }

  @override
  Future<UserEntity> signInWithAService(AuthService authService) {
    return datasource.signInWithAService(authService);
  }

  @override
  Future<UserEntity> login(String email, String password) {
    return datasource.login(email, password);
  }

  @override
  Future<void> logout() {
    return datasource.logout();
  }
}