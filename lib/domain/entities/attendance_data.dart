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

  factory AttendanceData.fromMap(Map<String, dynamic> json) => AttendanceData(
    dateDuration: json["dateDuration"],
    records: List<Record>.from(json["records"].map((x) => Record.fromMap(x))),
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

  factory Record.fromMap(Map<String, dynamic> json) => Record(
    date: DateTime.parse(json["date"]),
    text: json["name"] ?? json["day"],
    input: json["input"],
    output: json["output"],
    coffee: json["coffee"],
  );
}
