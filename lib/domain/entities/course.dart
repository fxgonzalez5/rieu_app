class Course {
  final String id;
  final String posterPath;
  final String name;
  final List<String> trainingPurposes;
  final String directedTo;
  final List<String> developingCompetences;
  final List<Section> sections;
  final String category;
  final List<Instructor> instructors;
  final String location;
  final String modality;
  final int duration;
  final String rating;
  final String schedule;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime creationDate;
  final DateTime applicationDeadline;
  final bool authorization;
  final Map<String, double?> registeredUsers;
  final int totalAuthorizedUsers;

  Course({
    required this.id,
    required this.posterPath,
    required this.name,
    required this.trainingPurposes,
    required this.directedTo,
    required this.developingCompetences,
    required this.sections,
    required this.category,
    required this.instructors,
    required this.location,
    required this.modality,
    required this.duration,
    required this.rating,
    required this.schedule,
    required this.startDate,
    required this.endDate,
    required this.creationDate,
    required this.applicationDeadline,
    required this.authorization,
    required this.registeredUsers,
    required this.totalAuthorizedUsers,
  });
}

class Instructor {
  final String photoPath;
  final String name;

  Instructor({
    required this.photoPath,
    required this.name,
  });
}

class Section {
  final String title;
  final String? content;

  Section({
    required this.title,
    required this.content,
  });
}