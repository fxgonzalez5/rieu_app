import 'package:flutter/foundation.dart';
import 'package:rieu/domain/entities/course.dart';

enum CourseStatus {available, pending, canceled, accepted}
typedef GetCourseCallback = Future<Course>Function(String movieId);

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
  CourseStatusData(status: CourseStatus.pending, text: 'Tu solicitud se encuentra', textButton: 'En revisión'),
  CourseStatusData(status: CourseStatus.canceled, text: 'Tu solicitud ha sido', textButton: 'Rechazada'),
];

class 
CourseProvider extends ChangeNotifier {
  final Map<String, Course> _coursesMap = {};
  final GetCourseCallback getCourse;
  String _errorMessage = '';

  CourseProvider({required this.getCourse});

  Map<String, Course> get coursesMap => _coursesMap;

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

  CourseStatusData getCourseStatusData(CourseStatus status) {
    return _courseStatusList.firstWhere((element) => element.status == status);
  }

}