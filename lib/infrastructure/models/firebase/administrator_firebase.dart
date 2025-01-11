import 'attendance_data_model.dart';

class AdministratorFirebase {
  final List<AttendanceDataModel>? attendanceData;

  AdministratorFirebase({
    required this.attendanceData,
  });

  factory AdministratorFirebase.fromMap(Map<String, dynamic> json) => AdministratorFirebase(
    attendanceData: json["attendanceData"] == null ? [] : List<AttendanceDataModel>.from(json["attendanceData"]!.map((x) => AttendanceDataModel.fromMap(x))),
  );
}
