import 'package:rieu/domain/entities/attendance_data.dart';

class UserEntity {
  final String id;
  final String? photoUrl;
  final String name;
  final String email;
  final List<String> roles;
  final String? institution;
  final String? city;
  final Map<String, List<AttendanceData>?> courses;
  final int totalCourses;
  final String mostActiveCourse;
  final int totalActiveCourses;
  final int totalCoursesCompleted;

  UserEntity({
    required this.id,
    this.photoUrl,
    required this.name,
    required this.email,
    this.roles = const ['user'],
    this.institution,
    this.city,
    this.courses = const {},
    this.totalCourses = 0,
    this.mostActiveCourse = 'Ninguno',
    this.totalActiveCourses = 0,
    this.totalCoursesCompleted = 0,
  });

  bool get isAdmin => roles.contains('admin');

  String get getRole {
    if (roles.contains('admin')) return 'Administrador';
    return 'Usuario';
  }

  UserEntity copyWith({
    String? id,
    String? photoUrl,
    String? name,
    String? email,
    String? institution,
    String? city,
  }) {
    return UserEntity(
      id: id ?? this.id,
      photoUrl: photoUrl ?? this.photoUrl,
      name: name ?? this.name,
      email: email ?? this.email,
      institution: institution ?? this.institution,
      city: city ?? this.city,
    );
  }
}