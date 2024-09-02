class AttendanceData {
  final String dateDuration;
  final List<Record> records;
  final int totalAttendance;

  AttendanceData({
    required this.dateDuration,
    required this.records,
    required this.totalAttendance,
  });

  AttendanceData copyWith({
    String? dateDuration,
    List<Record>? records,
    int? totalAttendance,
  }) => AttendanceData(
    dateDuration: dateDuration ?? this.dateDuration,
    records: records ?? this.records,
    totalAttendance: totalAttendance ?? this.totalAttendance,
  );

  factory AttendanceData.fromMap(Map<String, dynamic> json) => AttendanceData(
    dateDuration: json["dateDuration"],
    records: json["record"] != null
      ? List<Record>.from(json["record"].map((x) => Record.fromMap(x)))
      : List<Record>.from(json["week"].map((x) => Record.fromMap(x))),
    totalAttendance: json["totalAttendance"],
  );

  Map<String, dynamic> toMap() => {
    "dateDuration": dateDuration,
    "week": List<dynamic>.from(records.map((x) => x.toMap())),
    "totalAttendance": totalAttendance,
  };
}

class Record {
  final String name;
  final String input;
  final String output;
  final bool? coffee;

  Record({
    required this.name,
    required this.input,
    required this.output,
    required this.coffee,
  });

  Record copyWith({
    String? name,
    String? input,
    String? output,
    bool? coffee,
  }) => Record(
    name: name ?? this.name,
    input: input ?? this.input,
    output: output ?? this.output,
    coffee: coffee ?? this.coffee,
  );

  factory Record.fromMap(Map<String, dynamic> json) => Record(
    name: json["name"] ?? json["day"],
    input: json["input"],
    output: json["output"],
    coffee: json["coffee"],
  );

  Map<String, dynamic> toMap() => {
    "day": name,
    "input": input,
    "output": output,
    "coffee": coffee,
  };
}
