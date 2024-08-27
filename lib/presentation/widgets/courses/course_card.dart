import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rieu/config/theme/responsive.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => context.push('${GoRouterState.of(context).matchedLocation}/course/${'1'}'),
      child: Card(
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.only(bottom: responsive.hp(2.5)),
        color: colors.surface,
        child: Column(
          children: [
            Image.network(
              "https://via.placeholder.com/500/CC0000?text=Placeholder",
              width: double.infinity,
              height: responsive.hp(30),
              fit: BoxFit.cover,
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: responsive.hp(0.75), horizontal: responsive.wp(5)),
              titleTextStyle: texts.titleMedium,
              subtitleTextStyle: texts.bodyLarge!.copyWith(color: Colors.grey.shade600),
              title: Text('Protección jurídica de activos intelectuales'),
              subtitle: Row(
                children: [
                  Text('Por Diana Días'),
                  SizedBox(width: responsive.wp(10)),
                  Text('40 hrs'),
                  Spacer(),
                  Text('4.7'),
                  SizedBox(width: responsive.wp(1)),
                  Icon(
                    Icons.star_rate_rounded,
                    color: colors.secondary,
                    size: responsive.ip(1.5),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}