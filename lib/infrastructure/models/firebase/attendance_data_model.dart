class AttendanceDataModel {
  final String dateDuration;
  final List<RecordModel> records;

  AttendanceDataModel({
    required this.dateDuration,
    required this.records,
  });

  AttendanceDataModel copyWith({
    List<RecordModel>? records,
  }) => AttendanceDataModel(
    dateDuration: dateDuration,
    records: records ?? this.records,
  );

  factory AttendanceDataModel.fromMap(Map<String, dynamic> json, {String recordsKey = 'records'}) => AttendanceDataModel(
    dateDuration: json["dateDuration"],
    records: List<RecordModel>.from(json[recordsKey].map((x) => RecordModel.fromMap(x))),
  );

  Map<String, dynamic> toMap({bool isAdmin = false}) => {
    "dateDuration": dateDuration,
    isAdmin ? "records" : "week": List<dynamic>.from(records.map((x) => x.toMap(isAdmin))),
  };
}

class RecordModel {
  final DateTime date;
  final String? name;
  final String input;
  final String output;
  final bool coffee;

  RecordModel({
    required this.date,
    this.name,
    required this.input,
    required this.output,
    required this.coffee,
  });

  RecordModel copyWith({
    String? input,
    String? output,
    bool? coffee,
  }) => RecordModel(
    date: date,
    name: name,
    input: input ?? this.input,
    output: output ?? this.output,
    coffee: coffee ?? this.coffee,
  );

  factory RecordModel.fromMap(Map<String, dynamic> json) => RecordModel(
    date: DateTime.parse(json["date"]),
    name: json["name"],
    input: json["input"],
    output: json["output"],
    coffee: json["coffee"],
  );

  Map<String, dynamic> toMap(bool isAdmin) {
    final Map<String, dynamic> map = {
      "date": date.toIso8601String(),
      "input": input,
      "output": output,
      "coffee": coffee,
    };

    if (isAdmin) map["name"] = name;
    return map;
  }
}