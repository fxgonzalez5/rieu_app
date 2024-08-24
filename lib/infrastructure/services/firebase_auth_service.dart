import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Stream<User?> authStatus() {
    return _auth.authStateChanges();
  }

  static Future<UserCredential?> register(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // La cuenta ya existe para ese correo electrónico.
        print('The account already exists for that email.');
      } else if (e.code == 'weak-password') {
        // La contraseña proporcionada es demasiado débil.
        print('The password provided is too weak.');
      }
    } catch (e) {
      print('Error creating account');
    }
    return null;
  }

  static Future<UserCredential?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Ningún usuario encontrado para ese correo electrónico.
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        // Contraseña incorrecta proporcionada para ese usuario.
        print('Wrong password provided for that user.');
      } else if (e.code == 'invalid-credential') {
        // Credenciales no válidas proporcionadas.
        print('Invalid credentials provided.');
      }
    } catch (e) {
      print('Error login');
    }
    return null;
  }

  static Future<void> logout() async => await _auth.signOut();
}