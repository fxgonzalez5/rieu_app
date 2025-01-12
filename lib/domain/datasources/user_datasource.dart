import 'package:rieu/domain/entities/entities.dart';

abstract class UserDatasource {
  Future<UserEntity> getUserById(String id);
  Future<List<Course>> getUserCourses(List<String> courseIds, {int limit = 10, int offset = 0,});
  Future<Participant> toGradeCourse(String userId, String courseId, double rating);

  //* Se debe enviar el id del usuario que desea registrar la asistencia, 
  //* el userId que viene en la data del qr es del administrador
  Future<Participant> registerAttendance(String userId, QrData data, String qrType);
  Future<Participant> registerRefreshment(QrData data, String qrType);
}