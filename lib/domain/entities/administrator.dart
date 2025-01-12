import 'package:rieu/domain/entities/entities.dart';

class Administrator {
  final List<AttendanceData>? attendanceData;

  Administrator({
    this.attendanceData = const [],
  });
}