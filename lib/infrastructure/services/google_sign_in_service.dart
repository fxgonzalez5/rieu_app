import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/infrastructure/services/auth_service.dart';

class GoogleSingInService implements AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  @override
  Future<UserEntity> signInService() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await account?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;
      if (account == null || user == null) throw Exception('No se pudo iniciar sesión con Google, intente nuevamente');
      
      final userEntity = UserEntity(
        id: user.uid,
        photoUrl: account.photoUrl,
        name: account.displayName ?? 'Usuario Anónimo',
        email: account.email,
      );
      
      return userEntity;
    } catch (e) {
      throw Exception('Error al iniciar sesión con Google');
    }
  }

  @override
  Future<void> signOutService() async => await _googleSignIn.signOut();
}