import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/infrastructure/models/models.dart';

class AdministratorMapper {
  static Administrator administratorToEntity(AdministratorFirebase administratorFirebase) => Administrator(
    attendanceData: administratorFirebase.attendanceData?.map(
      (attendanceData) => AttendanceData(
        dateDuration: attendanceData.dateDuration,
        records: attendanceData.records.map(
          (record) => Record(
            date: record.date,
            text: record.name!,
            input: record.input,
            output: record.output,
            coffee: record.coffee,
          )
        ).toList(),
      )
    ).toList(),
  );

  static AdministratorFirebase administratorToModel(Administrator administrator) => AdministratorFirebase(
    attendanceData: administrator.attendanceData?.map(
      (attendanceData) => AttendanceDataModel(
        dateDuration: attendanceData.dateDuration,
        records: attendanceData.records.map(
          (record) => RecordModel(
            date: record.date,
            name: record.text,
            input: record.input,
            output: record.output,
            coffee: record.coffee,
          )
        ).toList(),
      )
    ).toList()
  );
}
