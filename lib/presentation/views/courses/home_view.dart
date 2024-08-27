import 'package:flutter/material.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/widgets/widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
      child: Column(
        children: [
          Align(
            heightFactor: responsive.hp(0.2),
            alignment: Alignment.centerLeft,
            child: Text('Destacados', style: texts.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return const CourseCard();
              },
            ),
          )
        ],
      ),
    );
  }
}
