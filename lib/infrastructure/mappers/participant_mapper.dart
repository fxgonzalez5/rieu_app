import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/infrastructure/models/models.dart';
import 'package:rieu/config/helpers/helpers.dart';

class ParticipantMapper {
  static Participant participantToEntity(ParticipantFirebase participantFirebase) => Participant(
    attendanceData: participantFirebase.attendanceData?.map(
      (attendanceData) => AttendanceData(
        dateDuration: attendanceData.dateDuration,
        records: attendanceData.records.map(
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

  static ParticipantFirebase participantToModel(Participant participant) => ParticipantFirebase(
    attendanceData: participant.attendanceData?.map(
      (attendanceData) => AttendanceDataModel(
        dateDuration: attendanceData.dateDuration,
        records: attendanceData.records.map(
          (record) => RecordModel(
            date: record.date,
            input: record.input,
            output: record.output,
            coffee: record.coffee,
          )
        ).toList(),
      )
    ).toList(),
    rating: participant.rating,
    status: participantStatusToString(participant.status),
  );
}
