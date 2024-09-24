import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rieu/domain/entities/entities.dart';

enum CourseStatus {available, unavailable, pending, canceled, accepted}
typedef GetCourseCallback = Future<Course>Function(String courseId);

class CourseStatusData {
  final CourseStatus status;
  final String text, textButton;

  const CourseStatusData({
    required this.status,
    required this.text,
    required this.textButton,
  });
}

const List<CourseStatusData> _administratorCourseStatuses = [
  CourseStatusData(status: CourseStatus.available, text: 'Curso disponible', textButton: 'Registrar'),
  CourseStatusData(status: CourseStatus.unavailable, text: 'Curso no disponible', textButton: ''),
];

const List<CourseStatusData> _courseStatusList = [
  CourseStatusData(status: CourseStatus.available, text: 'Participa en el curso', textButton: 'Inscribirme'),
  CourseStatusData(status: CourseStatus.unavailable, text: 'Tiempo de inscripción finalizado', textButton: ''),
  CourseStatusData(status: CourseStatus.pending, text: 'Tu solicitud se encuentra', textButton: 'En revisión'),
  CourseStatusData(status: CourseStatus.canceled, text: 'Tu solicitud ha sido', textButton: 'Rechazada'),
];

class CourseProvider extends ChangeNotifier {
  final Map<String, Course> _coursesMap = {};
  final Map<String, CourseStatus> _coursesStatusMap = {};
  final GetCourseCallback getCourse;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String _errorMessage = '';

  CourseProvider({required this.getCourse});

  Map<String, Course> get coursesMap => _coursesMap;
  Map<String, CourseStatus> get coursesStatusMap => _coursesStatusMap;
  set coursesStatusMap(Map<String, CourseStatus> value) {
    _coursesStatusMap.addAll(value);
    notifyListeners();
  }

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

  void fetchCourseStatus({required UserEntity user, required String courseId}) {
    if (!user.courses.containsKey(courseId)) {
      if (DateTime.now().isAfter(_coursesMap[courseId]!.applicationDeadline)) {
        _coursesStatusMap[courseId] = CourseStatus.unavailable;
      } else {
        _coursesStatusMap[courseId] = CourseStatus.available;
      }
    } else {
      final attendanceRecord = user.courses[courseId];

      if (attendanceRecord == null) {
        _coursesStatusMap[courseId] = CourseStatus.canceled;
      } else {
        if (attendanceRecord.isEmpty) {
          _coursesStatusMap[courseId] = CourseStatus.pending;
        } else {
          _coursesStatusMap[courseId] = CourseStatus.accepted;
        }
      }
    }
  }

  CourseStatusData getCourseStatusData(CourseStatus status, [bool isAdmin = false]) {
    if (isAdmin) {
      return _administratorCourseStatuses.firstWhere((element) => element.status == status);
    } 
    return _courseStatusList.firstWhere((element) => element.status == status);
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