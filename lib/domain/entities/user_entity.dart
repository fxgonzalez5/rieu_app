class UserEntity {
  final String id;
  final String? photoUrl;
  final String name;
  final String email;
  final List<String> roles;
  final String? institution;
  final String? city;
  final List<String> courses;
  final int totalCourses;
  final String mostActiveCourse;
  final int totalActiveCourses;
  final int totalCoursesCompleted;
  final List<String>? allowedCoursesTypes;

  UserEntity({
    required this.id,
    this.photoUrl,
    required this.name,
    required this.email,
    this.roles = const ['user'],
    this.institution,
    this.city,
    this.courses = const [],
    this.totalCourses = 0,
    this.mostActiveCourse = 'Ninguno',
    this.totalActiveCourses = 0,
    this.totalCoursesCompleted = 0,
    this.allowedCoursesTypes,
  });

  UserEntity copyWith({
    String? id,
    String? photoUrl,
    String? name,
    String? email,
    List<String>? roles,
    String? institution,
    String? city,
    List<String>? courses,
  }) {
    return UserEntity(
      id: id ?? this.id,
      photoUrl: photoUrl ?? this.photoUrl,
      name: name ?? this.name,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      institution: institution ?? this.institution,
      city: city ?? this.city,
      courses: courses ?? this.courses,
      totalCourses: totalCourses,
      mostActiveCourse: mostActiveCourse,
      totalActiveCourses: totalActiveCourses,
      totalCoursesCompleted: totalCoursesCompleted,
      allowedCoursesTypes: allowedCoursesTypes,
    );
  }

  factory UserEntity.fromMap(Map<String, dynamic> json) => UserEntity(
    id: json["id"],
    photoUrl: json["photo"],
    name: json["name"],
    email: json["email"],
    roles: List<String>.from(json["roles"].map((x) => x)),
    institution: json["institution"],
    city: json["city"],
    courses: List<String>.from(json["courses"].map((x) => x)),
    totalCourses: json["totalCourses"],
    mostActiveCourse: json["mostActiveCourse"],
    totalActiveCourses: json["totalActiveCourses"],
    totalCoursesCompleted: json["totalCoursesCompleted"],
    allowedCoursesTypes: json["allowedCoursesTypes"] != null ? List<String>.from(json["allowedCoursesTypes"].map((x) => x)) : null,
  );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      "id": id,
      "photo": photoUrl,
      "name": name,
      "email": email,
      "roles": List<String>.from(roles.map((x) => x)),
      "institution": institution,
      "city": city,
      "courses": List<String>.from(courses.map((x) => x)),
      "totalCourses": totalCourses,
      "mostActiveCourse": mostActiveCourse,
      "totalActiveCourses": totalActiveCourses,
      "totalCoursesCompleted": totalCoursesCompleted,
    };

    if (isAdmin) map["allowedCoursesTypes"] = allowedCoursesTypes != null ? List<String>.from(allowedCoursesTypes!.map((x) => x)) : null;
    return map;
  }

  bool get isAdmin => roles.contains('admin');

  String get getRole {
    if (roles.contains('admin')) return 'Administrador';
    return 'Usuario';
  }

}