import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rieu/domain/datasources/user_datasource.dart';
import 'package:rieu/domain/entities/course.dart';
import 'package:rieu/domain/entities/user_entity.dart';
import 'package:rieu/infrastructure/mappers/mappers.dart';

typedef GetCourseCallback = Future<Course>Function(String courseId);

class UserDatasourceImpl implements UserDatasource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GetCourseCallback getCourse;

  UserDatasourceImpl({required this.getCourse});

  @override
  Future<UserEntity> getUserById(String id) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await _db.collection('users').doc(id).get();
      final user = UserMapper.userJsonToEntity(snapshot.data()!);
      return user;
    } catch (e) {
      throw Exception('Error al obtener el usuario: $e');
    }
  }

  @override
  Future<List<Course>> getUserCourses(List<String> courseIds, {int limit = 10, int offset = 0}) async {
    try {
      final List<Course> courses = [];
      
      final int endIndex = (offset + limit) > courseIds.length 
        ? courseIds.length 
        : offset + limit;
      
      final paginatedIds = courseIds.sublist(offset, endIndex);
      
      for (final courseId in paginatedIds) {
        final course = await getCourse(courseId);
        courses.add(course);
      }
      return courses;
    } catch (e) {
      throw Exception('Error al obtener los cursos del usuario.\n$e');
    }
  }
}