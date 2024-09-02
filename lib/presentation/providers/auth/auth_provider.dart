import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/domain/repositories/auth_repository.dart';
import 'package:rieu/infrastructure/services/services.dart';

enum AuthStatus { checking, authenticated, unauthenticated }

class Alert {
  final String title;
  final String message;

  Alert({
    required this.title,
    required this.message,
  });
}

class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final String errorMessage;
  final Alert? alert;

  AuthState({
    this.status = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
    this.alert,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    bool? emailVerified,
    String? errorMessage,
    Alert? alert,
  }) => AuthState(
    status: status ?? this.status,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
    alert: alert ?? this.alert,
  );
}

class AuthProvider with ChangeNotifier {
  final AuthRepository authRepository;
  AuthState _state = AuthState();
  StreamSubscription<void>? _authSubscription;

  AuthProvider({
    required this.authRepository,
  }) {
    checkAuthStatus();
  }

  AuthState get state => _state;

  void _setLoggedUser(UserEntity user) async {
    _state = _state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
      errorMessage: '',
      alert: null
    );
    
    notifyListeners();
  }

  Future<void> logoutUser({List<AuthService> authServices = const [], String? errorMessage}) async {
    if (authServices.isNotEmpty) {
      for (final authService in authServices) {
        await authService.signOutService();
      }
    }
    await authRepository.logout();
    _state = _state.copyWith(
      status: AuthStatus.unauthenticated,
      user: null,
      errorMessage: errorMessage?.replaceAll('Exception: ', ''),
    );
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _state = _state.copyWith(errorMessage: '');
    notifyListeners();
  }

  Future<void> verifyUser(Alert alert) async {
    _state = _state.copyWith(alert: alert);
    notifyListeners();
  }

  void checkAuthStatus() {
    _authSubscription = authRepository.checkAuthStatus().listen(
      (user) {
        if (user == null) {
          logoutUser();
        } else {
          _setLoggedUser(user);
        }
      },
      onError: (e) {
        logoutUser(errorMessage: e.toString());
      }
    );
  }

  Future<void> registerUser(String name, String email, String password, String institution, String city) async {
    try {
      final user = await authRepository.register(name, email, password, institution, city);
      final emailVerified = await authRepository.verifyEmailAddress();
      if (!emailVerified) {
        verifyUser(
          Alert(
            title: 'Valida tu correo electrónico',
            message: 'Se ha enviado un correo de verificación a $email. Procede a validar tu cuenta para continuar.',
          ),
        );
      } 
      _setLoggedUser(user);
    } catch (e) {
      logoutUser(errorMessage: e.toString());
    }
  }

  Future<void> signInUser(AuthService authService) async {
    try {
      final user = await authRepository.signInWithAService(authService);
      _setLoggedUser(user);
    } catch (e) {
      logoutUser(errorMessage:  e.toString());
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } catch (e) {
      logoutUser(errorMessage: e.toString());
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}