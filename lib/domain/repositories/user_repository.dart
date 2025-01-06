import 'package:rieu/domain/entities/entities.dart';

abstract class UserRepository {
  Future<UserEntity> getUserById(String id);
  Future<List<Course>> getUserCourses(List<String> courseIds, {int limit = 10, int offset = 0});
  Future<void> updateCourseRating(String courseId, String userId, double rating);
  Future<void> registerAttendance(String userId, QrData data, String qrType, {int weekIndex = -1});
}