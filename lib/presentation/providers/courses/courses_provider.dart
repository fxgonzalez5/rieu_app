import 'package:flutter/widgets.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/domain/repositories/courses_repository.dart';

class CoursesProvider extends ChangeNotifier {
  final List<String> categories = ['Formación', 'Todo', 'Innovación', 'Encuentros Acad', 'Café Científico', 'Diálogos Éticos', 'Congresos', 'Otros'];
  String _currentCategory = 'Todo';
  final CoursesRepository coursesRepository;
  final int limit = 5;
  String lastCourseId = '';
  bool isLoading = false, isLastPage = false, hasSearch = false;
  final TextEditingController searchController = TextEditingController();
  final List<Course> courses = [];

  CoursesProvider({required this.coursesRepository}){
    loadNextPage();
  }

  String get currentCategory => _currentCategory;
  set currentCategory(String category) {
    if (_currentCategory == category && !hasSearch) return;

    _currentCategory = category;
    hasSearch = false;
    searchController.clear();
    resetPagination();
    loadNextPage();
    notifyListeners();
  }

  void resetPagination() {
    courses.clear();    
    lastCourseId = '';  
    isLastPage = false;
  }

  Future<List<Course>> loadCourses() async {
    if (hasSearch) return coursesRepository.getCourseBySearch(searchController.text, limit: limit, lastCourseId: lastCourseId);
    if (_currentCategory == 'Todo') return coursesRepository.getCourses(limit: limit, lastCourseId: lastCourseId);
    return coursesRepository.getCourseByCategory(_currentCategory, limit: limit, lastCourseId: lastCourseId);
  }

  Future<void> loadNextPage() async {
    if (isLoading || isLastPage) return;

    isLoading = true;
    notifyListeners();

    final newCourses = await loadCourses();
    if (newCourses.length < limit) isLastPage = true;

    courses.addAll(newCourses);
    if (newCourses.isNotEmpty) lastCourseId = newCourses.last.id;

    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleCourseSearch() async {
    if (searchController.text.isEmpty) return; 

    hasSearch = true;
    _currentCategory = 'Todo';
    resetPagination();
    loadNextPage();
  }
}