import 'package:rieu/domain/entities/course.dart';

abstract class CoursesDatasource {
  Future<List<Course>> getCourses({int limit = 10, int offset = 0, String lastCourseId = ''});
  Future<Course> getCourseById(String id);
  Future<List<Course>> getCourseByCategory(String category, {int limit = 10, int offset = 0, String lastCourseId = ''});
  Future<List<Course>> getCourseBySearch(String query, {int limit = 10, int offset = 0, String lastCourseId = ''});
}