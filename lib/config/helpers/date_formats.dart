import 'package:intl/intl.dart';
class DateFormats {
  static DateTime formatDateWithoutTime(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return DateTime.parse(formatter.format(date));
  }

  static List<List<DateTime>> getWeekGroups(DateTime startDate, DateTime endDate) {
    final List<List<DateTime>> weekGroups = [];
    List<DateTime> currentWeek = [];
    DateTime currentDate = startDate;
    
    while (currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
      // Agregar día actual al grupo actual
      currentWeek.add(currentDate);
      
      // Si es domingo o último día, completar el grupo
      if (currentDate.weekday == DateTime.sunday || currentDate.isAtSameMomentAs(endDate)) {
        weekGroups.add(List.from(currentWeek));
        currentWeek = [];
        
        // Si no es el último día, mover al siguiente lunes
        if (currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
          currentDate = currentDate.add(const Duration(days: 1));
        }
      } else {
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }
    
    // Si quedan días pendientes, agregar último grupo
    if (currentWeek.isNotEmpty) {
      weekGroups.add(currentWeek);
    }
    
    return weekGroups;
  }
}