import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/infrastructure/models/models.dart';

class CourseMapper {
  static Course courseFirebaseToEntity(CourseFirebase courseFirebase) => Course(
    id: courseFirebase.id,
    posterPath: courseFirebase.posterPath ?? 'https://firebasestorage.googleapis.com/v0/b/app-liid-9ede6.appspot.com/o/Course%2Fno-image.jpeg?alt=media&token=816cd4b6-3c53-4fce-bd79-1873853519ce',
    name: courseFirebase.courseName,
    trainingPurposes: courseFirebase.learningObjectives,
    directedTo: courseFirebase.participantsProfile,
    developingCompetences: courseFirebase.developingCompetences,
    sections: courseFirebase.sections.map((section) => Section(title: section.title, content: section.content)).toList(),
    category: courseFirebase.type,
    instructors: courseFirebase.instructors.map(
      (instructor) => Instructor(
        photoPath: instructor.photoPath ?? 'https://cdn-icons-png.flaticon.com/512/11879/11879720.png',
        name: instructor.name
      )
    ).toList(),
    location: courseFirebase.location,
    modality: courseFirebase.modality,
    duration: courseFirebase.duration,
    rating: courseFirebase.ratingAverage.toStringAsPrecision(2),
    schedule: courseFirebase.schedule,
    startDate: courseFirebase.startDate,
    endDate: courseFirebase.endDate,
    creationDate: courseFirebase.creationDate,
    applicationDeadline: courseFirebase.applicationDeadline,
    authorization: courseFirebase.authorization,
    registeredUsers: courseFirebase.registeredUsers,
    totalAuthorizedUsers: courseFirebase.totalAuthorizedUsers,
  );
}
