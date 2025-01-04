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

  Future<void> updateCourseRating(String courseId, double rating) async 
    => await userRepository.updateCourseRating(courseId, _user.id, rating);   
}