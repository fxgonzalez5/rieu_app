import 'package:rieu/domain/entities/entities.dart';

abstract class CoursesRepository {
  Future<List<Course>> getCourses({int limit = 10, int offset = 0, String lastCourseId = ''});
  Future<List<String>> getCategories();
  Future<Course> getCourseById(String id);
  Future<List<Course>> getCourseByCategory(String category, {int limit = 10, int offset = 0, String lastCourseId = ''});
  Future<List<Course>> getCourseBySearch(String query, {int limit = 10, int offset = 0, String lastCourseId = ''});
  Future<Administrator> getAdministratorById(String courseId, String userId);
  Future<Participant> getParticipantById(String courseId, String userId);

}