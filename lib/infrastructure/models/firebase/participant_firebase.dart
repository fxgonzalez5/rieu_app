import 'attendance_data_model.dart';

class ParticipantFirebase {
  final List<AttendanceDataModel>? attendanceData;
  final double? rating;
  final String status;

  ParticipantFirebase({
    required this.attendanceData,
    required this.rating,
    required this.status,
  });

  ParticipantFirebase copyWith({
    List<AttendanceDataModel>? attendanceData,
    double? rating,
  }) => ParticipantFirebase(
    attendanceData: attendanceData ?? this.attendanceData,
    rating: rating ?? this.rating,
    status: status,
  );

  factory ParticipantFirebase.fromMap(Map<String, dynamic> json) => ParticipantFirebase(
    attendanceData: json["attendanceData"] == null ? [] : List<AttendanceDataModel>.from(json["attendanceData"]!.map((x) => AttendanceDataModel.fromMap(x, recordsKey: 'week'))),
    rating: json["rating"]?.toDouble(),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "attendanceData": attendanceData == null ? null : List<dynamic>.from(attendanceData!.map((x) => x.toMap())),
    "rating": rating,
    "status": status,
  };
}
