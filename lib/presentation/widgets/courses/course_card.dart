import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rieu/config/helpers/text_formats.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/domain/entities/entities.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => context.push('${GoRouterState.of(context).matchedLocation}/course/${course.id}'),
      child: Card(
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.only(bottom: responsive.hp(2.5)),
        color: colors.surface,
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(color: Colors.grey.shade100),
              child: FadeInImage.assetNetwork(
                width: double.infinity,
                height: responsive.hp(25),
                placeholderScale: 1.75,
                placeholderFit: BoxFit.none,
                fit: BoxFit.cover,
                placeholder: 'assets/loaders/light_bulb_loading.gif', 
                image: course.posterPath,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: responsive.hp(0.75), horizontal: responsive.wp(5)),
              titleTextStyle: texts.titleMedium,
              subtitleTextStyle: texts.bodyLarge!.copyWith(color: Colors.grey.shade600),
              title: Text(course.name, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Row(
                children: [
                  SizedBox(
                    width: responsive.wp(30),
                    child: Text('Por ${TextFormats.extractNameAndLastName(course.instructors.first.name)}', maxLines: 1),
                  ),
                  const Spacer(),
                  Text('${course.duration} hrs'),
                  const Spacer(),
                  Text(course.rating),
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