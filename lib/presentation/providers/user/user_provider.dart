import 'package:flutter/widgets.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/domain/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository userRepository;
  UserEntity _user;
  List<Course> _courses = [];
  bool isLoading = false, _isLastPage = false;
  int page = 0;

  UserProvider({
    required this.userRepository,
    required UserEntity user,
  }) : _user = user {
    loadNextPage();
  } 

  UserEntity get user => _user;
  set user(UserEntity user) {
    _user = user;
    notifyListeners();
  }

  List<Course> get courses => _courses;

  Future<void> loadNextPage() async {
    if (isLoading || _isLastPage) return;

    isLoading = true;
    notifyListeners();

    final newCourses = await userRepository.getUserCourses(_user.courses, offset: page * 10);
    if (newCourses.isEmpty) {
      _isLastPage = true;
    } else {
      _courses = [..._courses, ...newCourses];
      page++;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> reloadCourses() async {
    _courses = [];
    _isLastPage = false;
    page = 0;
    await loadNextPage();
  }

  Future<Map<String, Participant>> toGradeCourse(String courseId, double rating) async {
    try {
      final participant = await userRepository.toGradeCourse(_user.id, courseId, rating);
      return {_user.id: participant};
    } catch (e) {
      throw Exception('Error al calificar el curso');
    }
  }

  Future<Map<String, Participant>> registerAttendance(QrData data, String qrType) async {
    try {
      final participant = _user.isAdmin 
        ? await userRepository.registerRefreshment(data, qrType) 
        : await userRepository.registerAttendance(_user.id, data, qrType);
      return {_user.id: participant};
    } catch (e) {
      if (e.toString().contains('Error:')) throw Exception('Error al registrar la asistencia');
      rethrow;
    }
  }
}