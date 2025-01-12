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
    this.attendanceData,
    this.rating,
    this.status = ParticipantStatus.pending,
  });

  Participant copyWith({
    List<AttendanceData>? attendanceData,
    double? rating,
  }) => Participant(
    attendanceData: attendanceData ?? this.attendanceData,
    rating: rating ?? this.rating,
    status: status
  );
}