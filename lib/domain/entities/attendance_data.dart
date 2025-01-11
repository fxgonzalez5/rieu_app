class AttendanceData {
  final String dateDuration;
  final List<Record> records;

  AttendanceData({
    required this.dateDuration,
    required this.records,
  });

  AttendanceData copyWith({
    List<Record>? records,
  }) => AttendanceData(
    dateDuration: dateDuration,
    records: records ?? this.records,
  );
}

class Record {
  final DateTime date;
  final String text;
  final String input;
  final String output;
  final bool coffee;

  Record({
    required this.date,
    required this.text,
    required this.input,
    required this.output,
    required this.coffee,
  });

  Record copyWith({
    String? input,
    String? output,
  }) => Record(
    date: date,
    text: text,
    input: input ?? this.input,
    output: output ?? this.output,
    coffee: coffee,
  );
}
