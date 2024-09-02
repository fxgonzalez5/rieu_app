import 'package:rieu/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUserById(String id);
}