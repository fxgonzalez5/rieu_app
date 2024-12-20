int calculateCourseProgress(DateTime startDate, DateTime endDate) {
  final currentDate = DateTime.now();
  if (currentDate.isBefore(startDate)) return 0;
  if (currentDate.isAfter(endDate)) return 100;

  final totalDays = endDate.difference(startDate).inDays;
  final daysPassed = currentDate.difference(startDate).inDays;

  if (daysPassed <= 0) return 0;

  final progressPercentage = ((daysPassed / totalDays) * 100).floor();
  return progressPercentage;
}