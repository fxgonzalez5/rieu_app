import 'package:flutter/widgets.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/domain/repositories/courses_repository.dart';

class CoursesProvider extends ChangeNotifier {
  final List<String> categories = ['Formación', 'Todo', 'Innovación', 'Encuentros Acad', 'Café Científico', 'Diálogos Éticos', 'Congresos', 'Otros'];
  String _currentCategory = 'Todo';
  final CoursesRepository coursesRepository;
  final int limit = 5;
  String lastCourseId = '';
  bool isLoading = false, isLastPage = false, _hasSearch = false, hasFiltered = false;
  final TextEditingController searchController = TextEditingController();
  final List<Course> courses = [], _backupCourses = [], userCourses = [], _backupUserCourses = [];

  CoursesProvider({required this.coursesRepository}) {
    loadNextPage();
  }

  String get currentCategory => _currentCategory;

  List<String> get userCoursesIds => _backupUserCourses.map((userCourse) => userCourse.id).toList();

  void _resetPagination() {
    courses.clear();    
    lastCourseId = '';  
    isLastPage = false;
  }

  Future<void> pageChanged(int pageIndex) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _currentCategory = 'Todo';
    searchController.clear();
    _hasSearch = false;
    hasFiltered = false;
    if (pageIndex == 1) {
      _filterUserCourses();
      return;
    }

    _resetPagination();
    courses.addAll(_backupCourses);
    notifyListeners();
  }

  Future<List<Course>> _loadCourses() async {
    if (_hasSearch) return coursesRepository.getCourseBySearch(searchController.text, limit: limit, lastCourseId: lastCourseId);
    if (_currentCategory == 'Todo') {
      hasFiltered = false;
      final newCourses = await coursesRepository.getCourses(limit: limit, lastCourseId: lastCourseId);
      _backupCourses.clear();
      _backupCourses.addAll(newCourses);
      return newCourses;
    }
    return coursesRepository.getCourseByCategory(_currentCategory, limit: limit, lastCourseId: lastCourseId);
  }

  Future<void> loadNextPage() async {
    if (isLoading || isLastPage) return;

    isLoading = true;
    notifyListeners();

    final newCourses = await _loadCourses();
    if (newCourses.length < limit) isLastPage = true;

    courses.addAll(newCourses);
    if (newCourses.isNotEmpty) lastCourseId = newCourses.last.id;

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadUserCourses(List<String> userCoursesIds) async {
    userCourses.clear();
    _backupUserCourses.clear();

    for (final courseId in userCoursesIds) {
      final userCourse = await coursesRepository.getCourseById(courseId);
      userCourses.add(userCourse);
    }
    _backupUserCourses.addAll(userCourses);

    notifyListeners();
  }

  void toggleCourseSearch([int pageIndex = 0])  {
    if (searchController.text.isEmpty) return; 

    _hasSearch = true;
    hasFiltered = false;
    _currentCategory = 'Todo';

    if (pageIndex == 1) {
      _searchInUserCourses();
      return;
    }

    _resetPagination();
    loadNextPage();
  }

  void _searchInUserCourses() {
    final coursesFound = _backupUserCourses.where((userCourse) {
      if (userCourse.name.toLowerCase().contains(searchController.text.toLowerCase())
        || userCourse.instructors.any(
          (instructor) => instructor.name.toLowerCase().contains(searchController.text.toLowerCase())
        )
      ) return true;
      return false;        
    });

    userCourses.clear();
    userCourses.addAll(coursesFound);
    notifyListeners();
  }

  void fetchCoursesByCategory(String category, [int pageIndex = 0])  {
    if (_currentCategory == category && !_hasSearch) return;

    hasFiltered = true;
    _currentCategory = category;
    searchController.clear();
    _hasSearch = false;

    if (pageIndex == 1) {
      _filterUserCourses();
      return;
    }

    _resetPagination();
    loadNextPage();
  }

  void _filterUserCourses() {
    if (_currentCategory == 'Todo') {
      hasFiltered = false;
      userCourses.clear();
      userCourses.addAll(_backupUserCourses);
      notifyListeners();
      return;
    }

    final coursesFound = _backupUserCourses.where((userCourse) => userCourse.category == _currentCategory);
    userCourses.clear();
    userCourses.addAll(coursesFound);
    notifyListeners();
  }
}