import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rieu/config/helpers/helpers.dart';
import 'package:rieu/domain/datasources/user_datasource.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/infrastructure/mappers/mappers.dart';
import 'package:rieu/infrastructure/models/models.dart';

typedef GetCourseCallback = Future<Course>Function(String courseId);

class UserDatasourceImpl implements UserDatasource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GetCourseCallback getCourse;

  UserDatasourceImpl({required this.getCourse});

  @override
  Future<UserEntity> getUserById(String id) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('users').doc(id).get();
      final user = UserMapper.userJsonToEntity(snapshot.data()!);
      return user;
    } catch (e) {
      throw Exception('Error al obtener el usuario: $e');
    }
  }

  @override
  Future<List<Course>> getUserCourses(List<String> courseIds, {int limit = 10, int offset = 0}) async {
    try {
      final List<Course> courses = [];
      
      final int endIndex = (offset + limit) > courseIds.length 
        ? courseIds.length 
        : offset + limit;
      
      final paginatedIds = courseIds.sublist(offset, endIndex);
      
      for (final courseId in paginatedIds) {
        final course = await getCourse(courseId);
        courses.add(course);
      }
      return courses;
    } catch (e) {
      throw Exception('Error al obtener los cursos del usuario.\n$e');
    }
  }

  @override
  Future<void> updateCourseRating(String courseId, String userId, double rating) async {
    try {
      final participantRef = _db.collection('courses').doc(courseId).collection('participants').withConverter(
        fromFirestore: (snapshot, _) => ParticipantFirebase.fromMap(snapshot.data()!),
        toFirestore: (model, _) => model.toMap(),
      );

      final participantDoc = await participantRef.doc(userId).get();
      if (!participantDoc.exists) throw Exception('Participante no encontrado');

      final ParticipantFirebase participant = participantDoc.data()!;
      final updatedParticipant = participant.copyWith(rating: rating);

      await participantRef.doc(userId).update(updatedParticipant.toMap());
    } catch (e) {
      throw Exception('Error al actualizar la calificación: $e');
    }
  }

  @override
  Future<void> registerAttendance(String userId, QrData data, String qrType, {int weekIndex = -1}) async {
    try {
      if (weekIndex.isNegative) throw Exception('Error al registrar asistencia: No se ha encontrado la semana correspondiente');

      final participantRef = _db.collection('courses').doc(data.courseId).collection('participants').withConverter(
        fromFirestore: (snapshot, _) => ParticipantFirebase.fromMap(snapshot.data()!),
        toFirestore: (model, _) => model.toMap(),
      );

      final participantDoc = await participantRef.doc(userId).get();
      if (!participantDoc.exists) throw Exception('Participante no encontrado');

      final ParticipantFirebase participant = participantDoc.data()!;
      final DateTime currentDay = DateFormats.formatDateWithoutTime(data.date);

      final List<Week> week = participant.attendanceData![weekIndex].week;
      final Week dayWeek = week.firstWhere((element) {
        final dateOfWeek = DateFormats.formatDateWithoutTime(element.date);
        return currentDay.isAtSameMomentAs(dateOfWeek);
      });

      // Actualizar la asistencia del día, según el tipo de registro, enviando la fecha y hora del registro
      final Week updatedDayWeek = dayWeek.copyWith(
        input: qrType == 'input' ? TextFormats.time(data.date, is24HourFormat: true) : dayWeek.input,
        output: qrType == 'output' ? TextFormats.time(data.date, is24HourFormat: true) : dayWeek.output,
      );

      // Crear la lista de las semanas con la asistencia del día actualizada
      final List<Week> updatedWeek = week.map((element) {
        final dateOfWeek = DateFormats.formatDateWithoutTime(element.date);
        return currentDay.isAtSameMomentAs(dateOfWeek) ? updatedDayWeek : element;
      }).toList();
            
      final AttendanceDataModel updatedAttendanceData = participant.attendanceData![weekIndex].copyWith(week: updatedWeek);
      final ParticipantFirebase updatedParticipant = participant.copyWith(
        attendanceData: participant.attendanceData!.map((element) => element.dateDuration == updatedAttendanceData.dateDuration ? updatedAttendanceData : element).toList(),
      );

      await participantRef.doc(userId).update(updatedParticipant.toMap());
    } catch (e) {
      throw Exception('Error al registrar asistencia: $e');
    }
  }
  
}