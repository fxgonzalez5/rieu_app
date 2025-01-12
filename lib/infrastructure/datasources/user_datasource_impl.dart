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
  Future<Participant> toGradeCourse(String userId, String courseId, double rating) async {
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
      return ParticipantMapper.participantToEntity(updatedParticipant);
    } catch (e) {
      if (e.runtimeType.toString() == '_Exception') rethrow;
      throw Exception('Error: $e');
    }
  }

  @override
  Future<Participant> registerAttendance(String userId, QrData data, String qrType) async {
    try {
      final Course course = await getCourse(data.courseId);
      final participantRef = _db.collection('courses').doc(data.courseId).collection('participants').withConverter(
        fromFirestore: (snapshot, _) => ParticipantFirebase.fromMap(snapshot.data()!),
        toFirestore: (model, _) => model.toMap(),
      );

      final participantDoc = await participantRef.doc(userId).get();
      if (!participantDoc.exists) throw Exception('Participante no encontrado');

      final ParticipantFirebase participant = participantDoc.data()!;
      final attendanceData = _registrationProcesses(course, participant, data, qrType);
      
      // Actualizar la asistencia del participante
      final ParticipantFirebase updatedParticipant = participant.copyWith(
        attendanceData: attendanceData
      );

      await participantRef.doc(userId).update(updatedParticipant.toMap());
      return ParticipantMapper.participantToEntity(updatedParticipant);
    } catch (e) {
      if (e.runtimeType.toString() == '_Exception') rethrow;
      throw Exception('Error: $e');
    }
  }
  
  @override
  Future<Participant> registerRefreshment(QrData data, String qrType) async {
    try {
      final Course course = await getCourse(data.courseId);
      final participantRef = _db.collection('courses').doc(data.courseId).collection('participants').withConverter(
        fromFirestore: (snapshot, _) => ParticipantFirebase.fromMap(snapshot.data()!),
        toFirestore: (model, _) => model.toMap(),
      );

      final participantDoc = await participantRef.doc(data.userId).get();
      if (!participantDoc.exists) throw Exception('Participante no encontrado');

      final ParticipantFirebase participant = participantDoc.data()!;
      final attendanceData = _registrationProcesses(course, participant, data, qrType);

      // Actualizar la asistencia del participante
      final ParticipantFirebase updatedParticipant = participant.copyWith(
        attendanceData: attendanceData
      );

      await participantRef.doc(data.userId).update(updatedParticipant.toMap());
      return ParticipantMapper.participantToEntity(updatedParticipant);
    } catch (e) {
      if (e.runtimeType.toString() == '_Exception') rethrow;
      throw Exception('Error: $e');
    }
  }

  List<AttendanceDataModel> _registrationProcesses(
    Course course,
    ParticipantFirebase participant,
    QrData data,
    String qrType,
  ) {
    final DateTime currentDay = DateFormats.formatDateWithoutTime(data.date);

    // Crear una lista de semanas del curso 
    final List<List<DateTime>> weekGroups = DateFormats.getWeekGroups(course.startDate, course.endDate);
    int weekIndex = -1;

    // Buscar la semana correspondiente a la fecha del registro
    for (int i = 0; i < weekGroups.length; i++) {
      final lastDayOfWeek = DateFormats.formatDateWithoutTime(weekGroups[i].last);
      if (currentDay.isBefore(lastDayOfWeek) || currentDay.isAtSameMomentAs(lastDayOfWeek)) {
        weekIndex = i;
        break;
      }
    }

    // Si no se encontró la semana correspondiente
    if (weekIndex == -1) throw Exception('No se ha encontrado la semana correspondiente para el registro');

    final List<RecordModel> records = participant.attendanceData![weekIndex].records;
    final RecordModel record = records.firstWhere((element) {
      final dateOfRecord = DateFormats.formatDateWithoutTime(element.date);
      return currentDay.isAtSameMomentAs(dateOfRecord);
    });

    // Si ya se ha registrado la asistencia para el día de hoy
    if ((qrType == 'input' && record.input != "No Registrada") 
      || (qrType == 'output' && record.output != "No Registrada")) throw Exception('Ya ha registrado la asistencia de ${qrType == 'input' ? 'entrada' : 'salida'}');

    // Si ya se ha registrado el refrigerio para la persona
    if (qrType == 'coffee' && record.coffee) throw Exception('Ya ha registrado el refrigerio de esta persona');

    // Crear el registro de asistencia del día actualizado
    final RecordModel updatedRecord = record.copyWith(
      input: qrType == 'input' ? TextFormats.time(data.date, is24HourFormat: true) : record.input,
      output: qrType == 'output' ? TextFormats.time(data.date, is24HourFormat: true) : record.output,
      coffee: qrType == 'coffee' ? true : record.coffee,
    );

    // Crear la lista de las registros con la asistencia del día actualizada
    final List<RecordModel> updatedRecords = records.map((element) {
      final dateOfWeek = DateFormats.formatDateWithoutTime(element.date);
      return currentDay.isAtSameMomentAs(dateOfWeek) ? updatedRecord : element;
    }).toList();
            
    // Crear el registro de asistencia actualizado
    final AttendanceDataModel updatedAttendanceData = participant.attendanceData![weekIndex].copyWith(records: updatedRecords);      
    final List<AttendanceDataModel> attendanceData = participant.attendanceData!;
    attendanceData[weekIndex] = updatedAttendanceData;

    return attendanceData;
  }
  
}