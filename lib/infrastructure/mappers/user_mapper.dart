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
  };

  static UserEntity userJsonToEntity(Map<String, dynamic> json) => UserEntity(
    id: json['id'],
    photoUrl: json['photo'],
    name: json['name'],
    email: json['email'],
    roles: List<String>.from(json['roles'].map((role) => role)),
    institution: json['institution'],
    city: json['city'],
    courses: List<Map<String, dynamic>>.from(json['courses'].map((course) => course)),
  );
}