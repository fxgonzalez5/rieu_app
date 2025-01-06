import 'package:rieu/domain/entities/entities.dart';

abstract class UserDatasource {
  Future<UserEntity> getUserById(String id);
  Future<List<Course>> getUserCourses(List<String> courseIds, {int limit = 10, int offset = 0,});
  Future<void> updateCourseRating(String courseId, String userId, double rating);

  //* Se debe enviar el id del usuario que desea registrar la asistencia, 
  //* el userId que viene en la data del qr es del administrador
  Future<void> registerAttendance(String userId, QrData data, String qrType, {int weekIndex = -1});
}