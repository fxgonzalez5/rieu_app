import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:rieu/domain/entities/entities.dart';

typedef GetCourseCallback = Future<Course>Function(String courseId);
typedef LeaveRatingCallback = Future<Map<String, Participant>> Function(String courseId, double rating);
typedef MarkAttendanceCallback = Future<Map<String, Participant>> Function(QrData data, String qrType);

class CourseProvider extends ChangeNotifier {
  final Map<String, Course> _coursesMap = {};
  final Map<String, CourseStatusData> _coursesStatusMap = {};
  final GetCourseCallback getCourse;
  final LeaveRatingCallback leaveRating;
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

  CourseProvider({required this.getCourse, required this.leaveRating, required this.markAttendance});

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

  Future<void> updateTheParticipantRating(String courseId, double rating) async {
    try {
      final participantMap = await leaveRating(courseId, rating);
      final participant = participantMap.values.single;
      final course = _coursesMap[courseId]!;

      course.updateParticipant(participantMap.keys.single, participant);
      _coursesMap[courseId] = course;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Stream<bool> onQRViewCreated(QRViewController controller, String qrType) async* {
    yield* controller.scannedDataStream.asyncMap((scanData) async {
      try {
        if (scanData.code == null || scanData.code!.trim().isEmpty) {
          controller.pauseCamera();
          throw Exception('El código QR no es válido');
        }

        try {
          final data = QrData.fromJson(scanData.code!);
          controller.pauseCamera();

          await _updateParticipantAttendance(data, qrType);
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

  Future<void> _updateParticipantAttendance(QrData data, String qrType) async {
    try {
      final participantMap = await markAttendance(data, qrType);
      final participant = participantMap.values.single;
      final course = _coursesMap[data.courseId]!;

      course.updateParticipant(participantMap.keys.single, participant);
      _coursesMap[data.courseId] = course;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

}