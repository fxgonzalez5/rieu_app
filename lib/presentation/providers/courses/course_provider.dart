import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:rieu/config/helpers/helpers.dart';
import 'package:rieu/domain/entities/entities.dart';

typedef GetCourseCallback = Future<Course>Function(String courseId);
typedef MarkAttendanceCallback = Future<void> Function(QrData data, String qrType, int weekIndex);

class CourseProvider extends ChangeNotifier {
  final Map<String, Course> _coursesMap = {};
  final Map<String, CourseStatusData> _coursesStatusMap = {};
  final GetCourseCallback getCourse;
  final MarkAttendanceCallback markAttendance;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String _errorMessage = '';

  static const List<CourseStatusData> _administratorCourseStatuses = [
    CourseStatusData(status: CourseStatus.available, text: 'Curso disponible', textButton: 'Registrar'),
    CourseStatusData(status: CourseStatus.unavailable, text: 'Curso no disponible', textButton: ''),
  ];

  static const List<CourseStatusData> _courseStatusList = [
    CourseStatusData(status: CourseStatus.available, text: 'Participa en el curso', textButton: 'Inscribirme'),
    CourseStatusData(status: CourseStatus.unavailable, text: 'Tiempo de inscripción finalizado', textButton: ''),
    CourseStatusData(status: CourseStatus.accepted, text: '', textButton: ''),
    CourseStatusData(status: CourseStatus.pending, text: 'Tu solicitud se encuentra', textButton: 'En revisión'),
    CourseStatusData(status: CourseStatus.canceled, text: 'Tu solicitud ha sido', textButton: 'Rechazada'),
  ];

  CourseProvider({required this.getCourse, required this.markAttendance});

  Map<String, Course> get coursesMap => _coursesMap;
  Map<String, CourseStatusData> get coursesStatusMap => _coursesStatusMap;

  String get errorMessage => _errorMessage;
  void resetErrorMessage() {
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> loadCourse(String courseId) async {
    if (_coursesMap[courseId] != null) return;

    try {
      final course = await getCourse(courseId);
      _coursesMap[courseId] = course;
    } catch (e) {
      _errorMessage = 'No se puede cargar el curso';
    }
    notifyListeners();
  }

  void fetchCourseStatus({required String courseId, required String userId, required bool isAdmin}) {
    final course = _coursesMap[courseId]!;

    if (isAdmin) {
      // TODO: Implementar lógica para administradores
      _coursesStatusMap[courseId] = _courseStatusList.firstWhere((element) => element.status == CourseStatus.accepted);
    } else {
      final participant = course.getParticipant(userId);
  
      if (participant == null) {
        if (DateTime.now().isAfter(course.applicationDeadline)) {
          _coursesStatusMap[courseId] = _courseStatusList.firstWhere((element) => element.status == CourseStatus.unavailable);
        } else {
          _coursesStatusMap[courseId] = _courseStatusList.firstWhere((element) => element.status == CourseStatus.available);
        }
      } else {
        switch (participant.status) {
          case ParticipantStatus.accepted:
            _coursesStatusMap[courseId] = _courseStatusList.firstWhere((element) => element.status == CourseStatus.accepted);
            break;
          case ParticipantStatus.pending:
            _coursesStatusMap[courseId] = _courseStatusList.firstWhere((element) => element.status == CourseStatus.pending);
            break;
          case ParticipantStatus.rejected:
            _coursesStatusMap[courseId] = _courseStatusList.firstWhere((element) => element.status == CourseStatus.canceled);
            break;
        }
      }
    }
  }

  void updateLocalCourseRating(String courseId, String userId, double rating) {
    final course = _coursesMap[courseId]!;
    final participant = course.getParticipant(userId)!;
    final updatedParticipant = participant.copyWith(rating: rating);

    course.updateParticipant(userId, updatedParticipant);
    _coursesMap[courseId] = course;
    notifyListeners();
  }

  Stream<bool> onQRViewCreated(QRViewController controller, String userId, String qrType) async* {
    yield* controller.scannedDataStream.asyncMap((scanData) async {
      try {
        if (scanData.code == null || scanData.code!.trim().isEmpty) {
          controller.pauseCamera();
          throw Exception('El código QR no es válido');
        }

        try {
          final data = QrData.fromJson(scanData.code!);
          controller.pauseCamera();

          final weekIndex = _updateLocalCourseAttendance(userId, data, qrType);
          switch (weekIndex) {
            case -1:
              throw Exception('No se ha encontrado la semana correspondiente para el registro');
            case -2:
              throw Exception('Ya se ha registrado la asistencia para el día de hoy');
          }

          await markAttendance(data, qrType, weekIndex);
          return true;
        } catch (e) {
          if (e.runtimeType.toString() == "_TypeError") throw Exception('El código QR no tiene el formato correcto');
          if (e.toString().contains('encontrado')) throw Exception('Error al registrar asistencia, intente en otro momento');
          if (e.toString().contains('registrado')) rethrow;
          throw Exception('Error al realizar el registro, intente nuevamente.');
        }
      } catch (e) {
        controller.pauseCamera();
        rethrow;
      }
    });
  }

  int _updateLocalCourseAttendance(String userId, QrData data, String qrType) {
    final course = _coursesMap[data.courseId]!;
    final participant = course.getParticipant(userId)!;

    // Crear una lista de semanas del curso 
    final DateTime currentDay = DateFormats.formatDateWithoutTime(data.date);
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

    if (weekIndex.isNegative) return -1;

    final List<Record> records = participant.attendanceData![weekIndex].records;
    final Record record = records.firstWhere((element) {
      final dateOfRecord = DateFormats.formatDateWithoutTime(element.date);
      return currentDay.isAtSameMomentAs(dateOfRecord);
    });

    if ((qrType == 'input' && record.input != "No Registrada") 
      || (qrType == 'output' && record.output != "No Registrada")) return -2;

    // Actualizar la asistencia del día, enviando la hora del registro
    final Record updatedRecord = record.copyWith(
      input: qrType == 'input' ? TextFormats.time(data.date, is24HourFormat: true) : record.input,
      output: qrType == 'output' ? TextFormats.time(data.date, is24HourFormat: true) : record.output,
    );

    // Crear la lista de los registros con la asistencia del día actualizada
    final List<Record> updatedRecords = records.map((element) {
      final dateOfRecord = DateFormats.formatDateWithoutTime(element.date);
      return currentDay.isAtSameMomentAs(dateOfRecord) ? updatedRecord : element;
    }).toList();

    final AttendanceData updatedAttendanceData = participant.attendanceData![weekIndex].copyWith(records: updatedRecords);
    final Participant updatedParticipant = participant.copyWith(
      attendanceData: participant.attendanceData!.map((element) => element.dateDuration == updatedAttendanceData.dateDuration ? updatedAttendanceData : element).toList(),
    );

    course.updateParticipant(userId, updatedParticipant);
    _coursesMap[data.courseId] = course;
    notifyListeners();

    return weekIndex;
  }

}