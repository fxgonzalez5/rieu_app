import 'package:rieu/domain/datasources/courses_datasource.dart';
import 'package:rieu/domain/entities/course.dart';
import 'package:rieu/domain/repositories/courses_repository.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesDatasource datasource;

  CoursesRepositoryImpl(this.datasource);
  
  @override
  Future<List<Course>> getCourses({int limit = 10, int offset = 0, String lastCourseId = ''}) {
    return datasource.getCourses(limit: limit, offset: offset, lastCourseId: lastCourseId);
  }

  @override
  Future<List<Course>> getCourseByCategory(String category, {int limit = 10, int offset = 0, String lastCourseId = ''}) {
    return datasource.getCourseByCategory(category, limit: limit, offset: offset, lastCourseId: lastCourseId);
  }

  @override
  Future<Course> getCourseById(String id) {
    return datasource.getCourseById(id);
  }

  @override
  Future<List<Course>> getCourseBySearch(String query, {int limit = 10, int offset = 0, String lastCourseId = ''}) {
    return datasource.getCourseBySearch(query, limit: limit, offset: offset, lastCourseId: lastCourseId);
  }
}