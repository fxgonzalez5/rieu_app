import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/infrastructure/models/models.dart';

class CourseMapper {
  static Course courseFirebaseToEntity(CourseFirebase courseFirebase) => Course(
    id: courseFirebase.id,
    posterPath: courseFirebase.posterPath ?? 'https://iglesiadeconcepcion.cl/wp-content/themes/theme-arzobispado/includes/img/imagen-no-disponible.jpeg',
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
  );
}
