import 'package:flutter/foundation.dart';

enum CourseStatus {available, pending, canceled, accepted}

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

class CourseProvider extends ChangeNotifier {
  CourseStatusData getCourseStatusData(CourseStatus status) {
    return _courseStatusList.firstWhere((element) => element.status == status);
  }

}