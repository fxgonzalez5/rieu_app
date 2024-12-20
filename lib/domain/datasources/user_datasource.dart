import 'package:rieu/domain/entities/entities.dart';

abstract class UserDatasource {
  Future<UserEntity> getUserById(String id);
  Future<List<Course>> getUserCourses(List<String> courseIds, {int limit = 10, int offset = 0,});
}