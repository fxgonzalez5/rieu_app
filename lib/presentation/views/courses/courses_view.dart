import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rieu/config/helpers/helpers.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/providers/providers.dart';
import 'package:rieu/presentation/widgets/widgets.dart';

class CoursesView extends StatefulWidget {
  const CoursesView({super.key});

  @override
  State<CoursesView> createState() => _CoursesViewState();
}

class _CoursesViewState extends State<CoursesView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final userProvider = context.read<UserProvider>();
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 250) >= scrollController.position.maxScrollExtent) {
        userProvider.loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final coursesProvider = context.watch<CoursesProvider>();

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
