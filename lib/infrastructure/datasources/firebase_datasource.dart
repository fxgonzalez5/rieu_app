import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rieu/domain/datasources/courses_datasource.dart';
import 'package:rieu/domain/entities/administrator.dart';
import 'package:rieu/domain/entities/course.dart';
import 'package:rieu/domain/entities/participant.dart';
import 'package:rieu/infrastructure/mappers/mappers.dart';
import 'package:rieu/infrastructure/models/models.dart';

class FirebaseDataSource implements CoursesDatasource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<Course>> getCourses({int limit = 10, int offset = 0, String lastCourseId = ''}) async {
    try {
      final coursesFirebase = _db.collection('courses')
        .withConverter(
          fromFirestore: (snapshot, _) => CourseFirebase.fromMap(snapshot.data()!),
          toFirestore: (model, _) => model.toMap(),
        );

      Query<CourseFirebase> query; 
      if (lastCourseId.isEmpty) {
        query = coursesFirebase.orderBy('creationDate', descending: true).limit(limit);
      } else {
        final lastCourse = await coursesFirebase.doc(lastCourseId).get();
        query = coursesFirebase.orderBy('creationDate', descending: true).startAfterDocument(lastCourse).limit(limit);
      }

      final querySnapshot = await query.get();
      
      final List<Course> courses = [];
      for (final doc in querySnapshot.docs) {
        final administrators = await getAdministratorsForCourse(doc.id);
        final participants = await getParticipantsForCourse(doc.id);
        final course = CourseMapper.courseFirebaseToEntity(doc.data(), administrators, participants);
        courses.add(course);
      }

      return courses;
    } catch (e) {
      throw Exception('Error al obtener los cursos: $e');
    }
  }

  @override
  Future<List<Map<String, Administrator>>> getAdministratorsForCourse(String courseId) async {
    try {
      final administratorsFirebase = await _db.collection('courses').doc(courseId).collection('administrators').get();

      if (administratorsFirebase.docs.isEmpty) return [];

      final List<Map<String, Administrator>> administrators = [];
      for (final doc in administratorsFirebase.docs) {
        final administrator = AdministratorMapper.administratorToEntity(AdministratorFirebase.fromMap(doc.data()));
        administrators.add({doc.id: administrator});
      }

      return administrators;
    } catch (e) {
      throw Exception('Error al obtener los administradores para el curso $courseId: $e');
    }
  }

  @override
  Future<List<Map<String, Participant>>> getParticipantsForCourse(String courseId) async {
    try {
      final participantsFirebase = await _db.collection('courses').doc(courseId).collection('participants').get();

      if (participantsFirebase.docs.isEmpty) return [];

      final List<Map<String, Participant>> participants = [];
      for (final doc in participantsFirebase.docs) {
        final participant = ParticipantMapper.participantToEntity(ParticipantFirebase.fromMap(doc.data()));
        participants.add({doc.id: participant});
      }

      return participants;
    } catch (e) {
      throw Exception('Error al obtener los participantes para el curso $courseId: $e');
    }
  }

  @override
  Future<List<Course>> getCourseByCategory(String category, {int limit = 10, int offset = 0, String lastCourseId = ''}) async {
    try {
      final coursesFirebase = _db.collection('courses')
        .withConverter(
          fromFirestore: (snapshot, _) => CourseFirebase.fromMap(snapshot.data()!),
          toFirestore: (model, _) => model.toMap(),
        );

      Query<CourseFirebase> query; 
      if (lastCourseId.isEmpty) {
        query = coursesFirebase.where('type', isEqualTo: category).orderBy('creationDate', descending: true).limit(limit);
      } else {
        final lastCourse = await coursesFirebase.doc(lastCourseId).get();
        query = coursesFirebase.where('type', isEqualTo: category).orderBy('creationDate', descending: true).startAfterDocument(lastCourse).limit(limit);
      }

      final querySnapshot = await query.get();

      final List<Course> courses = [];
      for (final doc in querySnapshot.docs) {
        final administrators = await getAdministratorsForCourse(doc.id);
        final participants = await getParticipantsForCourse(doc.id);
        final course = CourseMapper.courseFirebaseToEntity(doc.data(), administrators, participants);
        courses.add(course);
      }

      return courses;
    } catch (e) {
      throw Exception('Error al obtener los cursos: $e');
    }
  }

  @override
  Future<List<Course>> getCourseBySearch(String term, {int limit = 10, int offset = 0, String lastCourseId = ''}) async {
    try {
      final coursesFirebase = _db.collection('courses')
        .withConverter(
          fromFirestore: (snapshot, _) => CourseFirebase.fromMap(snapshot.data()!),
          toFirestore: (model, _) => model.toMap(),
        );
      
      Query<CourseFirebase> query;
      if (lastCourseId.isEmpty) {
        query = coursesFirebase.where('courseName', isGreaterThanOrEqualTo: term).orderBy('courseName').limit(limit);
      } else {
        final lastCourse = await coursesFirebase.doc(lastCourseId).get();
        query = coursesFirebase.where('courseName', isGreaterThanOrEqualTo: term).orderBy('courseName').startAfterDocument(lastCourse).limit(limit);
      }
      
      final querySnapshot = await query.get();
      
      final List<Course> courses = [];
      for (final doc in querySnapshot.docs) {
        final administrators = await getAdministratorsForCourse(doc.id);
        final participants = await getParticipantsForCourse(doc.id);
        final course = CourseMapper.courseFirebaseToEntity(doc.data(), administrators, participants);
        courses.add(course);
      }

      return courses;
    } catch (e) {
      throw Exception('Error al obtener los cursos: $e');
    }
  }

  @override
  Future<Course> getCourseById(String id) async {
    try {
      final courseFirebase = _db.collection('courses').doc(id)
        .withConverter(
          fromFirestore: (snapshot, _) => CourseFirebase.fromMap(snapshot.data()!),
          toFirestore: (model, _) => model.toMap(),
        );

      final course = await courseFirebase.get();
      final administrators = await getAdministratorsForCourse(id);
      final participants = await getParticipantsForCourse(id);

      return CourseMapper.courseFirebaseToEntity(course.data()!, administrators, participants);
    } catch (e) {
      throw Exception('Error al obtener el curso: $e');
    }
  }
}