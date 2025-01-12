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
  Future<Participant> toGradeCourse(String userId, String courseId, double rating) {
    return datasource.toGradeCourse(userId, courseId, rating);	
  }

  @override
  Future<Participant> registerAttendance(String userId, QrData data, String qrType) {
    return datasource.registerAttendance(userId, data, qrType);
  }
  
  @override
  Future<Participant> registerRefreshment(QrData data, String qrType) {
    return datasource.registerRefreshment(data, qrType);
  }

}