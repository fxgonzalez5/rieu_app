import 'package:rieu/domain/entities/user_entity.dart';

abstract class UserDatasource {
  Future<UserEntity> getUserById(String id);
}