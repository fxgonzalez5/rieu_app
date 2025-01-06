import 'package:rieu/domain/datasources/user_datasource.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/domain/repositories/repositories.dart';
import 'package:rieu/infrastructure/datasources/user_datasource_impl.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDatasource datasource;
  final CoursesRepository coursesRepository;

  UserRepositoryImpl({
    UserDatasource? datasource,
    required this.coursesRepository,
  }) : datasource = datasource ?? UserDatasourceImpl(getCourse: coursesRepository.getCourseById);

  @override
  Future<UserEntity> getUserById(String id) {
    return datasource.getUserById(id);
  }

  @override
  Future<List<Course>> getUserCourses(List<String> courseIds, {int limit = 10, int offset = 0}) {
    return datasource.getUserCourses(courseIds, limit: limit, offset: offset);
  }
  
  @override
  Future<void> updateCourseRating(String courseId, String userId, double rating) {
    return datasource.updateCourseRating(courseId, userId, rating);	
  }

  @override
  Future<void> registerAttendance(String userId, QrData data, String qrType, {int weekIndex = -1}) {
    return datasource.registerAttendance(userId, data, qrType, weekIndex: weekIndex);
  }

}