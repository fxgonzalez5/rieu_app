import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rieu/config/theme/responsive.dart';

class CourseListItem extends StatelessWidget {
  final String courseId, imageUrl, title, subtitle;
  final int progress;
  final DateTime startDate, endDate;

  const CourseListItem({
    super.key,
    required this.courseId,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.progress = 0,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.hp(0.75)),
      child: GestureDetector(
        onTap: () => context.push('${GoRouterState.of(context).matchedLocation}/course/$courseId'),
        child: SizedBox(
          height: responsive.wp(27.5),
          child: Row(
            children: [
              _CoverImage(imageUrl),
              SizedBox(width: responsive.wp(5)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: texts.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    _Subtitle(subtitle),
                    _CustomProgress(progress, startDate, endDate),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomProgress extends StatelessWidget {
  final int progress;
  final DateTime startDate, endDate;
  const _CustomProgress(this.progress, this.startDate, this.endDate);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;

    String progressStatus() {
      if (DateTime.now().isBefore(startDate)) return 'No iniciado';
      if (DateTime.now().isAfter(endDate)) return 'Finalizado';
      return 'En curso';
    }

    return Column(
      children: [
        SizedBox(height: responsive.hp(1)),
        LinearProgressIndicator(
          backgroundColor: Colors.grey.shade300,
          color: colors.secondary,
          minHeight: responsive.hp(0.75),
          borderRadius: BorderRadius.circular(responsive.ip(0.5)),
          value: progress / 100,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: responsive.wp(1.5)),
          child: Row(
            children: [
              Text('$progress%'),
              const Spacer(),
              Text(progressStatus(), style: TextStyle(color: Colors.grey.shade600),)
            ],
          ),
        )
      ],
    );
  }
}

class _Subtitle extends StatelessWidget {
  final String text;

  const _Subtitle(this.text);

  @override
  Widget build(BuildContext context) {
    final texts = Theme.of(context).textTheme;

    return RichText(
      maxLines: 1,
      text: TextSpan(
        text: 'Instructor(a): ',
        style: texts.bodyMedium!.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
        children: [
          TextSpan(text: text, style: texts.bodyMedium)
        ]
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  final String imageUrl;

  const _CoverImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.ip(1))
      ),
      elevation: responsive.ip(0.75),
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.grey.shade100),
        child: FadeInImage.assetNetwork(
          width: responsive.wp(35),
          height: double.infinity,
          placeholderScale: 3,
          placeholderFit: BoxFit.none,
          fit: BoxFit.cover,
          placeholder: 'assets/loaders/light_bulb_loading.gif', 
          image: imageUrl,
        ),
      ),
    );
  }
}