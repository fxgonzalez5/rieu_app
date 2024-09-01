import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rieu/domain/datasources/courses_datasource.dart';
import 'package:rieu/domain/entities/course.dart';
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
      final courses = querySnapshot.docs.map((course) => CourseMapper.courseFirebaseToEntity(course.data())).toList();

      return courses;
    } catch (e) {
      throw Exception('Error al obtener los cursos: $e');
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
      final courses = querySnapshot.docs.map((course) => CourseMapper.courseFirebaseToEntity(course.data())).toList();

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
      final courses = querySnapshot.docs.map((course) => CourseMapper.courseFirebaseToEntity(course.data())).toList();

      return courses;
    } catch (e) {
      throw Exception('Error al obtener los cursos: $e');
    }
  }

  @override
  Future<Course> getCourseById(String id) {
    try {
      final courseFirebase = _db.collection('courses').doc(id)
        .withConverter(
          fromFirestore: (snapshot, _) => CourseFirebase.fromMap(snapshot.data()!),
          toFirestore: (model, _) => model.toMap(),
        );

      final course = courseFirebase.get().then((course) => CourseMapper.courseFirebaseToEntity(course.data()!));

      return course;
    } catch (e) {
      throw Exception('Error al obtener el curso: $e');
    }
  }

}