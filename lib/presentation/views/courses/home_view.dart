import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/providers/providers.dart';
import 'package:rieu/presentation/widgets/widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final coursesProvider = context.read<CoursesProvider>();
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 250) >= scrollController.position.maxScrollExtent) {
        if (!coursesProvider.isLastPage) coursesProvider.loadNextPage();
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

    if (coursesProvider.courses.isEmpty && coursesProvider.isLoading) {
      return Center(
        child: Image(
          image: const AssetImage('assets/loaders/spin_loading.gif'),
          width: responsive.wp(15),
        ),
      );
    }

    if (coursesProvider.courses.isEmpty) {
      return const Center(
        child: Text('No hay cursos disponibles'),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
      itemCount: coursesProvider.courses.length,
      itemBuilder: (BuildContext context, int index) {
        final course = coursesProvider.courses[index];
        return CourseCard(course: course);
      },
    );
  }
}
