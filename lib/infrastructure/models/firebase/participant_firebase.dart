class ParticipantFirebase {
  final List<AttendanceDataModel>? attendanceData;
  final double? rating;
  final String status;

  ParticipantFirebase({
    required this.attendanceData,
    required this.rating,
    required this.status,
  });

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
  final String day;
  final String input;
  final String output;
  final bool? coffee;

  Week({
    required this.day,
    required this.input,
    required this.output,
    required this.coffee,
  });

  factory Week.fromMap(Map<String, dynamic> json) => Week(
    day: json["day"],
    input: json["input"],
    output: json["output"],
    coffee: json["coffee"],
  );

  Map<String, dynamic> toMap() => {
    "day": day,
    "input": input,
    "output": output,
    "coffee": coffee,
  };
}
