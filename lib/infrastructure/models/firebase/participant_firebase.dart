class ParticipantFirebase {
  final List<AttendanceDataModel>? attendanceData;
  final double? rating;
  final String status;

  ParticipantFirebase({
    required this.attendanceData,
    required this.rating,
    required this.status,
  });

  ParticipantFirebase copyWith({
    List<AttendanceDataModel>? attendanceData,
    double? rating,
  }) => ParticipantFirebase(
    attendanceData: attendanceData ?? this.attendanceData,
    rating: rating ?? this.rating,
    status: status,
  );

  factory ParticipantFirebase.fromMap(Map<String, dynamic> json) => ParticipantFirebase(
    attendanceData: json["attendanceData"] == null ? [] : List<AttendanceDataModel>.from(json["attendanceData"]!.map((x) => AttendanceDataModel.fromMap(x))),
    rating: json["rating"]?.toDouble(),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "attendanceData": attendanceData == null ? [] : List<dynamic>.from(attendanceData!.map((x) => x.toMap())),
    "rating": rating,
    "status": status,
  };
}

class AttendanceDataModel {
  final String dateDuration;
  final List<Week> week;

  AttendanceDataModel({
    required this.dateDuration,
    required this.week,
  });

  AttendanceDataModel copyWith({
    List<Week>? week,
  }) => AttendanceDataModel(
    dateDuration: dateDuration,
    week: week ?? this.week,
  );

  factory AttendanceDataModel.fromMap(Map<String, dynamic> json) => AttendanceDataModel(
    dateDuration: json["dateDuration"],
    week: List<Week>.from(json["week"].map((x) => Week.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "dateDuration": dateDuration,
    "week": List<dynamic>.from(week.map((x) => x.toMap())),
  };
}

class Week {
  final DateTime date;
  final String input;
  final String output;
  final bool coffee;

  Week({
    required this.date,
    required this.input,
    required this.output,
    required this.coffee,
  });

  Week copyWith({
    String? input,
    String? output,
    bool? coffee,
  }) => Week(
    date: date,
    input: input ?? this.input,
    output: output ?? this.output,
    coffee: coffee ?? this.coffee,
  );

  factory Week.fromMap(Map<String, dynamic> json) => Week(
    date: DateTime.parse(json["date"]),
    input: json["input"],
    output: json["output"],
    coffee: json["coffee"],
  );

  Map<String, dynamic> toMap() => {
    "date": date.toIso8601String(),
    "input": input,
    "output": output,
    "coffee": coffee,
  };
}
