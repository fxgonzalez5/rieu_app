class UserEntity {
  final String id;
  final String? photoUrl;
  final String name;
  final String email;
  final List<String> roles;
  final String? institution;
  final String? city;

  UserEntity({
    required this.id,
    this.photoUrl,
    required this.name,
    required this.email,
    this.roles = const ['user'],
    this.institution,
    this.city,
  });

  bool get isAdmin => roles.contains('admin');
}