import 'package:rieu/domain/entities/entities.dart';

abstract class UserDatasource {
  Future<UserEntity> getUserById(String id);
  Future<List<Course>> getUserCourses(List<String> courseIds, {int limit = 10, int offset = 0,});
  Future<void> updateCourseRating(String courseId, String userId, double rating);
}