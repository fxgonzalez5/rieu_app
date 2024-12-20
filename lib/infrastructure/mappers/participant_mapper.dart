import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/infrastructure/models/models.dart';

class ParticipantMapper {
  static Participant participantToEntity(ParticipantFirebase participantFirebase) => Participant(
    attendanceData: participantFirebase.attendanceData?.map(
      (attendanceData) => AttendanceData(
        dateDuration: attendanceData.dateDuration,
        records: attendanceData.week.map(
          (record) => Record(
            name: record.day,
            input: record.input,
            output: record.output,
            coffee: record.coffee,
          )
        ).toList(),
      )
    ).toList(),
    rating: participantFirebase.rating,
    status: parseParticipantStatus(participantFirebase.status),
  );
}
