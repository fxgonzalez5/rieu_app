enum CourseStatus {available, unavailable, pending, canceled, accepted}

class CourseStatusData {
  final CourseStatus status;
  final String text, textButton;

  const CourseStatusData({
    required this.status,
    required this.text,
    required this.textButton,
  });
}