import 'package:rieu/domain/entities/entities.dart';

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
  final List<Map<String, Participant>> participants;
  final int totalAuthorizedParticipants;

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
    required this.participants,
    required this.totalAuthorizedParticipants,
  });

  Participant? getParticipant(String userId) {
    final participant = participants.firstWhere((element) => element.keys.first == userId, orElse: () => {});
    return participant[userId];
  }

  void updateParticipant(String userId, Participant participant) {
    final index = participants.indexWhere((element) => element.keys.first == userId);
    if (index != -1) {
      participants[index][userId] = participant;
    }
  }
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