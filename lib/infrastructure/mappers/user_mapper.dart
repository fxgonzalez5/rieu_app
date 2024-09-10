import 'package:rieu/domain/entities/entities.dart';

class UserMapper {
  static Map<String, dynamic> userEntityToJson(UserEntity user) => {
    'id': user.id,
    'photo': user.photoUrl,
    'name': user.name,
    'email': user.email,
    'roles': user.roles,
    'institution': user.institution,
    'city': user.city,
    'courses': user.courses,
    'totalCourses': user.totalCourses,
    'mostActiveCourse': user.mostActiveCourse,
    'totalActiveCourses': user.totalActiveCourses,
    'totalCoursesCompleted': user.totalCoursesCompleted,
  };

  static UserEntity userJsonToEntity(Map<String, dynamic> json) => UserEntity(
    id: json['id'],
    photoUrl: json['photo'],
    name: json['name'],
    email: json['email'],
    roles: List<String>.from(json['roles'].map((role) => role)),
    institution: json['institution'],
    city: json['city'],
    courses: Map.from(json["courses"]).map(
      (k, v) => MapEntry<String, List<AttendanceData>?>(k, v == null ? null : List<AttendanceData>.from(v!.map((x) => AttendanceData.fromMap(x))))
    ),
    totalCourses: json['totalCourses'],
    mostActiveCourse: json['mostActiveCourse'],
    totalActiveCourses: json['totalActiveCourses'],
    totalCoursesCompleted: json['totalCoursesCompleted'],
    allowedCoursesTypes: json['allowedCoursesTypes'] == null ? null : List<String>.from(json['allowedCoursesTypes'].map((type) => type)),
  );
}