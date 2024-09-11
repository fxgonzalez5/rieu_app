class CourseFirebase {
  final String id;
  final String? posterPath;
  final String courseName;
  final List<String> learningObjectives;
  final String participantsProfile;
  final List<String> developingCompetences;
  final List<SectionModel> sections;
  final String type;
  final List<InstructorModel> instructors;
  final String location;
  final String modality;
  final int duration;
  final double ratingAverage;
  final String schedule;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime creationDate;
  final DateTime applicationDeadline;
  final bool authorization;
  final List<String> registeredAdministrators;
  final Map<String, double?> registeredUsers;
  final int totalAuthorizedUsers;

  CourseFirebase({
    required this.id,
    required this.posterPath,
    required this.courseName,
    required this.learningObjectives,
    required this.participantsProfile,
    required this.developingCompetences,
    required this.sections,
    required this.type,
    required this.instructors,
    required this.location,
    required this.modality,
    required this.duration,
    required this.ratingAverage,
    required this.schedule,
    required this.startDate,
    required this.endDate,
    required this.creationDate,
    required this.applicationDeadline,
    required this.authorization,
    required this.registeredAdministrators,
    required this.registeredUsers,
    required this.totalAuthorizedUsers,
  });

  factory CourseFirebase.fromMap(Map<String, dynamic> json) => CourseFirebase(
    id: json["id"],
    posterPath: json["posterPath"],
    courseName: json["courseName"],
    learningObjectives: List<String>.from(json["learningObjectives"].map((x) => x)),
    participantsProfile: json["participantsProfile"],
    developingCompetences: List<String>.from(json["developingCompetences"].map((x) => x)),
    sections: List<SectionModel>.from(json["sections"].map((x) => SectionModel.fromMap(x))),
    type: json["type"],
    instructors: List<InstructorModel>.from(json["instructors"].map((x) => InstructorModel.fromMap(x))),
    location: json["location"],
    modality: json["modality"],
    duration: json["duration"],
    ratingAverage: json["ratingAverage"].toDouble(),
    schedule: json["schedule"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    creationDate: DateTime.parse(json["creationDate"]),
    applicationDeadline: DateTime.parse(json["applicationDeadline"]),
    authorization: json["authorization"],
    registeredAdministrators: List<String>.from(json["registeredAdministrators"].map((x) => x)),
    registeredUsers: Map<String, double?>.from(json["registeredUsers"]).map((k, v) => MapEntry<String, double?>(k, v)),
    totalAuthorizedUsers: json["totalAuthorizedUsers"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "posterPath": posterPath,
    "courseName": courseName,
    "learningObjectives": List<String>.from(learningObjectives.map((x) => x)),
    "participantProfile": participantsProfile,
    "developingCompetences": List<String>.from(developingCompetences.map((x) => x)),
    "sections": List<SectionModel>.from(sections.map((x) => x.toMap())),
    "type": type,
    "instructors": List<InstructorModel>.from(instructors.map((x) => x.toMap())),
    "location": location,
    "modality": modality,
    "duration": duration,
    "ratingAverage": ratingAverage,
    "schedule": schedule,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "creationDate": creationDate.toIso8601String(),
    "applicationDeadline": applicationDeadline.toIso8601String(),
    "authorization": authorization,
    "registeredAdministrators": List<dynamic>.from(registeredAdministrators.map((x) => x)),
    "registeredUsers": Map<String, double?>.from(registeredUsers).map((k, v) => MapEntry<String, double?>(k, v)),
    "totalAuthorizedUsers": totalAuthorizedUsers,
  };
}

class InstructorModel {
  final String name;
  final String? photoPath;

  InstructorModel({
    required this.name,
    required this.photoPath,
  });

  factory InstructorModel.fromMap(Map<String, dynamic> json) => InstructorModel(
    name: json["name"],
    photoPath: json["photoPath"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "photoPath": photoPath,
  };
}

class SectionModel {
  final String title;
  final String? content;

  SectionModel({
    required this.title,
    required this.content,
  });

  factory SectionModel.fromMap(Map<String, dynamic> json) => SectionModel(
    title: json["title"],
    content: json["content"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "content": content,
  };
}
