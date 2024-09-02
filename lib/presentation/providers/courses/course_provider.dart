import 'package:flutter/foundation.dart';
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

  CourseStatusData getCourseStatusData(CourseStatus status) {
    return _courseStatusList.firstWhere((element) => element.status == status);
  }
}