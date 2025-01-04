import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:rieu/domain/entities/entities.dart';

typedef GetCourseCallback = Future<Course>Function(String courseId);

class CourseProvider extends ChangeNotifier {
  final Map<String, Course> _coursesMap = {};
  final Map<String, CourseStatusData> _coursesStatusMap = {};
  final GetCourseCallback getCourse;
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

  CourseProvider({required this.getCourse});

  Map<String, Course> get coursesMap => _coursesMap;
  Map<String, CourseStatusData> get coursesStatusMap => _coursesStatusMap;

  String get errorMessage => _errorMessage;
  set errorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  Future<void> loadCourse(String courseId) async {
    if (_coursesMap[courseId] != null) return;

    try {
      final course = await getCourse(courseId);
      _coursesMap[courseId] = course;
    } catch (e) {
      errorMessage = 'No se puede cargar el curso';
    }
    notifyListeners();
  }

  void fetchCourseStatus({required String courseId, required String userId, required bool isAdmin}) {
    final course = _coursesMap[courseId]!;

    if (isAdmin) {
      // TODO: Implementar lógica para administradores
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

  Stream<bool> onQRViewCreated(QRViewController controller, String qrType) async* {
    yield* controller.scannedDataStream.asyncMap((scanData) async {
      try {
        if (scanData.code == null) {
          controller.pauseCamera();
          return false;
        }

        final jsonMap = jsonDecode(scanData.code!);
        controller.pauseCamera();

        if (jsonMap is Map && jsonMap.isNotEmpty) {
          /// El modelo de jsonMap a utilizar es el siguiente:
          /// {
          ///   "userId": "String",
          ///   "date": "DateTime",
          ///   "courseId": "String",
          /// }
          final Map<String, String> result = jsonMap.map((key, value) => MapEntry(key, value));
          try {
            await Future.delayed(const Duration(seconds: 1));
            return true;
          } catch (e) {
            throw Exception('Error al realizar el registro, intente nuevamente.');
          }
        } 
        return false;
      } catch (e) {
        if (e.toString().contains('Error')) rethrow;
        controller.pauseCamera();
        return false;
      }
    });
  }

}