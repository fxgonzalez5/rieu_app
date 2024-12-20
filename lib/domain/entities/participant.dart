import 'package:rieu/domain/entities/entities.dart';

enum ParticipantStatus { accepted, pending, rejected }

ParticipantStatus parseParticipantStatus(String status) {
  switch (status.toLowerCase()) {
    case 'aceptado':
      return ParticipantStatus.accepted;
    case 'pendiente':
      return ParticipantStatus.pending;
    case 'rechazado':
      return ParticipantStatus.rejected;
    default:
      throw ArgumentError('Invalid participant status: $status');
  }
}

String participantStatusToString(ParticipantStatus status) {
  switch (status) {
    case ParticipantStatus.accepted:
      return 'aceptado';
    case ParticipantStatus.pending:
      return 'pendiente';
    case ParticipantStatus.rejected:
      return 'rechazado';
  }
}

class Participant {
  final List<AttendanceData>? attendanceData;
  final double? rating;
  final ParticipantStatus status;

  Participant({
    required this.attendanceData,
    required this.rating,
    required this.status,
  });

  factory Participant.fromMap(Map<String, dynamic> json) => Participant(
    attendanceData: json["attendanceData"] == null ? null : List<AttendanceData>.from(json["attendanceData"]!.map((x) => AttendanceData.fromMap(x))),
    rating: json["rating"]?.toDouble(),
    status: parseParticipantStatus(json["status"]),
  );

  Map<String, dynamic> toMap() => {
    "attendanceData": attendanceData == null ? [] : List<AttendanceData>.from(attendanceData!.map((x) => x.toMap())),
    "rating": rating,
    "status": participantStatusToString(status),
  };
}