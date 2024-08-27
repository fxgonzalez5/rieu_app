import 'package:flutter/foundation.dart';

class CoursesProvider extends ChangeNotifier {
  final List<String> categories = ['Formación', 'Todo', 'Innovación', 'Encuentros Acad', 'Café Científico', 'Diálogos Éticos', 'Congresos', 'Otros'];
  String _currentCategory = 'Todo';

  String get currentCategory => _currentCategory;
  set currentCategory(String category) {
    _currentCategory = category;
    notifyListeners();
  }
}