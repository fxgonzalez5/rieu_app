import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/infrastructure/models/models.dart';
import 'package:rieu/config/helpers/helpers.dart';

class ParticipantMapper {
  static Participant participantToEntity(ParticipantFirebase participantFirebase) => Participant(
    attendanceData: participantFirebase.attendanceData?.map(
      (attendanceData) => AttendanceData(
        dateDuration: attendanceData.dateDuration,
        records: attendanceData.week.map(
          (record) => Record(
            date: record.date,
            text: TextFormats.day(record.date),
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
