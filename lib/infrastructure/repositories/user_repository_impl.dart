import 'package:rieu/domain/datasources/user_datasource.dart';
import 'package:rieu/domain/entities/user_entity.dart';
import 'package:rieu/domain/repositories/user_repository.dart';
import 'package:rieu/infrastructure/datasources/user_datasource_impl.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDatasource datasource;

  UserRepositoryImpl({
    UserDatasource? datasource
  }) : datasource = datasource ?? UserDatasourceImpl();

  @override
  Future<UserEntity> getUserById(String id) {
    return datasource.getUserById(id);
  }
}