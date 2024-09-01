class UserEntity {
  final String id;
  final String? photoUrl;
  final String name;
  final String email;
  final List<String> roles;
  final String? institution;
  final String? city;
  final List<Map<String, dynamic>> courses;

  UserEntity({
    required this.id,
    this.photoUrl,
    required this.name,
    required this.email,
    this.roles = const ['user'],
    this.institution,
    this.city,
    this.courses = const [],
  });

  bool get isAdmin => roles.contains('admin');

  String get getRole {
    if (roles.contains('admin')) return 'Administrador';
    return 'Usuario';
  }
}