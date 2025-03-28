import 'package:flutter/widgets.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/domain/repositories/courses_repository.dart';

class CoursesProvider extends ChangeNotifier {
  final CoursesRepository coursesRepository;
  final List<Course> userCourses;
  final TextEditingController searchController = TextEditingController();
  final List<String> categories = ['Todo'];
  final List<Course> courses = [], _backupCourses = [], _backupUserCourses = [];
  final int limit = 5;
  String _currentCategory = 'Todo', _lastCourseId = '';
  bool isLoading = false, _isLastPage = false, _hasSearch = false, hasFiltered = false;

  CoursesProvider({required this.coursesRepository, required this.userCourses}) {
    loadNextPage();
    loadCategories();
  }

  String get currentCategory => _currentCategory;

  void _updateList(List<Course> currentList, List<Course> newList) {
    currentList.clear();
    currentList.addAll(newList);
  }

  void _updateUserCourses(List<Course> newUserCourses) {
    userCourses.clear();
    userCourses.addAll(newUserCourses);
    _backupUserCourses.clear();
    _backupUserCourses.addAll(newUserCourses);
  }

  void _resetSearch() {
    searchController.clear();
    _hasSearch = false;
  }

  void _resetCategory() {
    _currentCategory = 'Todo';
    hasFiltered = false;
  }
  
  void _resetPagination() {
    courses.clear();    
    _lastCourseId = '';  
    _isLastPage = false;
  }

  Future<List<Course>> _loadCourses() async {
    if (_hasSearch) return coursesRepository.getCourseBySearch(searchController.text, limit: limit, lastCourseId: _lastCourseId);
    if (hasFiltered) return coursesRepository.getCourseByCategory(_currentCategory, limit: limit, lastCourseId: _lastCourseId);
    
    final newCourses = await coursesRepository.getCourses(limit: limit, lastCourseId: _lastCourseId);
    _updateList(_backupCourses, newCourses);
    return newCourses;
  }

  Future<void> loadNextPage() async {
    if (isLoading || _isLastPage) return;

    isLoading = true;
    notifyListeners();

    final newCourses = await _loadCourses();
    if (newCourses.length < limit) _isLastPage = true;

    courses.addAll(newCourses);
    if (newCourses.isNotEmpty) _lastCourseId = newCourses.last.id;

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    final newCategories = await coursesRepository.getCategories();
    newCategories.sort((a, b) => a.compareTo(b));
    categories.addAll(newCategories);
    notifyListeners();
  }

  void loadUserCourses(List<Course> newUserCourses) {
    _updateUserCourses(newUserCourses);
    
    if (_hasSearch) return _searchInUserCourses();
    if (hasFiltered) return _filterUserCoursesByCategory();

    notifyListeners();
  }

  Future<void> pageChanged(int pageIndex) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _resetSearch();
    _resetCategory();
    _updateList(courses, _backupCourses);
    notifyListeners();
  }

  void toggleCourseSearch([int pageIndex = 0])  {
    if (searchController.text.isEmpty && _hasSearch) {
      _resetSearch();
      _updateList(courses, _backupCourses);
      notifyListeners();
      return;
    }
    if (searchController.text.isEmpty) return; 

    _hasSearch = true;
    _resetCategory();

    if (pageIndex == 1) return _searchInUserCourses();

    _resetPagination();
    loadNextPage();
  }

  void _searchInUserCourses() {
    final term = searchController.text.toLowerCase().trim();

    final coursesFound = _backupUserCourses.where((userCourse) => userCourse.name.toLowerCase().contains(term));
    final instructorsFound = _backupUserCourses.where((userCourse) => userCourse.instructors.any(
      (instructor) => instructor.name.toLowerCase().contains(term)
    ));

    final uniqueCourses = {...coursesFound, ...instructorsFound}.toList();

    _updateList(userCourses, uniqueCourses);
    notifyListeners();
  }

  void fetchCoursesByCategory(String category, [int pageIndex = 0])  {
    if (_currentCategory == category && !_hasSearch) return;

    if (_currentCategory != category) _currentCategory = category;
    hasFiltered = (category != 'Todo');
    _resetSearch();

    if (pageIndex == 1) return _filterUserCoursesByCategory();

    _resetPagination();
    loadNextPage();
  }

  void _filterUserCoursesByCategory() {
    if (!hasFiltered) {
      _updateList(userCourses, _backupUserCourses);
      notifyListeners();
      return;
    }

    final coursesFound = _backupUserCourses.where((userCourse) => userCourse.category == _currentCategory).toList();
    _updateList(userCourses, coursesFound);
    notifyListeners();
  }
}