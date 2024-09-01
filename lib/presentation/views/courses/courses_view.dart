import 'package:flutter/material.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/widgets/widgets.dart';

class CoursesView extends StatelessWidget {
  const CoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return const CourseListItem(
          imageUrl: "https://via.placeholder.com/500/FF5500?text=Placeholder",
          title: "Resiliencia personal y familiar en tiempos de post pandemia",
          subtitle: "Diana Díaz Alférez",
          progress: 25,
          session: 3,
        );
      },
    );
  }
}
