import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rieu/domain/datasources/user_datasource.dart';
import 'package:rieu/domain/entities/user_entity.dart';
import 'package:rieu/infrastructure/mappers/mappers.dart';

class UserDatasourceImpl implements UserDatasource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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


}