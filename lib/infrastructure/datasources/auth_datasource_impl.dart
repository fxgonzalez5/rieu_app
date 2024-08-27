import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rieu/domain/datasources/auth_datasource.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/infrastructure/mappers/mappers.dart';
import 'package:rieu/infrastructure/services/auth_service.dart';

class AuthDataSourceImpl implements AuthDataSource {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserEntity?> checkAuthStatus() async {
    try {
      final user = await _auth.authStateChanges().first;
      if (user == null) return null;

      final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('users').doc(user.uid).get();
      final userEntity = UserMapper.userJsonToEntity(snapshot.data()!);
      return userEntity;
    } catch (e) {
      throw Exception('Autenticación fallida');
    }
  }

  @override
  Future<UserEntity> register(String name, email, password, institution, city) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = credential.user;
      if (user != null) {
        await user.sendEmailVerification();
        await user.updateDisplayName(name);
      }

      final userEntity = UserEntity(
        id: user!.uid,
        name: name,
        email: email,
        institution: institution,
        city: city,
      );

      final userJson = UserMapper.userEntityToJson(userEntity);
      await _firestore.collection('users').doc(user.uid).set(userJson);
      return userEntity;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // La cuenta ya existe para ese correo electrónico.
        throw Exception('Ya existe una cuenta con ese correo');
      } else if (e.code == 'weak-password') {
        // La contraseña proporcionada es demasiado débil.
        throw Exception('La contraseña es débil');
      }
      throw Exception('No se pudo registrar su información, intente nuevamente');
    } catch (e) {
      throw Exception('Error al registrarte');
    }
  }

  @override
  Future<bool> verifyEmailAddress() async {
    try {
      final user = await _auth.userChanges().first;
      return user!.emailVerified;
    } catch (e) {
      throw Exception('Error al verificar el correo electrónico');
    }
  }

  @override
  Future<UserEntity> signInWithAService(AuthService authService) async {
    try {
      final userEntity = await authService.signInService();
      final document = await _firestore.collection('users').doc(userEntity.id).get();
      if (document.exists) return userEntity;
      
      final userJson = UserMapper.userEntityToJson(userEntity);
      await _firestore.collection('users').doc(userEntity.id).set(userJson);
      return userEntity;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity> login(String email, password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('users').doc(credential.user!.uid).get();
      final userEntity = UserMapper.userJsonToEntity(snapshot.data()!);
      return userEntity;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Ningún usuario encontrado para ese correo electrónico.
        throw Exception('No existe un usuario con ese correo electrónico');
      } else if (e.code == 'wrong-password') {
        // Contraseña incorrecta proporcionada para ese usuario.
        throw Exception('Contraseña incorrecta');
      } else if (e.code == 'invalid-credential') {
        // Credenciales no válidas proporcionadas.
        throw Exception('Credenciales inválidas');
      }
      throw Exception('No se pudo iniciar sesión, intente nuevamente');
    } catch (e) {
      throw Exception('Error al iniciar sesión');
    }
  }

  @override
  Future<void> logout() async => await _auth.signOut();
}