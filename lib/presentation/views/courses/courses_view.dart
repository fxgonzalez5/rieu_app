import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/providers/providers.dart';
import 'package:rieu/presentation/widgets/widgets.dart';

class CoursesView extends StatelessWidget {
  const CoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final coursesProvider = context.watch<CoursesProvider>();

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

    if (coursesProvider.userCourses.isEmpty && coursesProvider.hasFiltered) {
      return const Center(
        child: Text('No posees cursos de esta categoría'),
      );
    }

    if (coursesProvider.userCourses.isEmpty) {
      return const Center(
        child: Text('Aún no te has inscrito a ningún curso'),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
      itemCount: coursesProvider.userCourses.length,
      itemBuilder: (context, index) {
        final course = coursesProvider.userCourses[index];

        return CourseListItem(
          courseId: course.id,
          imageUrl: course.posterPath,
          title: course.name,
          subtitle: course.instructors.first.name,
          progress: calculateCourseProgress(course.startDate, course.endDate),
          startDate: course.startDate,
          endDate: course.endDate,
        );
      },
    );
  }
}
