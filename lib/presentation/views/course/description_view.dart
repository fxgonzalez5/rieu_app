import 'package:flutter/material.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/domain/entities/entities.dart';
import 'package:rieu/presentation/widgets/widgets.dart';

class DescriptionView extends StatelessWidget {
  final Course course;
  final bool isActive;
  
  const DescriptionView({
    super.key,
    required this.course,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildMainText(
            context,
            detail: course.trainingPurposes,
            profile: course.directedTo
          ),
          SizedBox(height: responsive.hp(2)),
          Text('Competencias a desarrollar', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: course.developingCompetences.length,
            itemBuilder: (BuildContext context, int index) {
              final String text = course.developingCompetences[index];

              return ListItem(
                number: index + 1,
                text: text
              );
            },
          ),
          if (isActive) SizedBox(height: responsive.hp(10)),
        ],
      ),
    );
  }

  Column buildMainText(context, {required List<String> detail, required String profile}) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;

    Widget buildDetail() {
      if (detail.length == 1) return Text(detail.first);
      return Column(children: List.generate(detail.length, (index) => ListItem(text: detail[index])),);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Finalidades de la formación', style: texts.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: responsive.hp(1)),
        buildDetail(),
        SizedBox(height: responsive.hp(1)),
        Text('Dirigido a', style: texts.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
        Text(profile),
      ],
    );
  }
}