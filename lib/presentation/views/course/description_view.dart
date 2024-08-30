import 'package:flutter/material.dart';
import 'package:rieu/config/helpers/text_formats.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/widgets/widgets.dart';

class DescriptionView extends StatelessWidget {
  final bool isActive;
  
  const DescriptionView({
    super.key,
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
            detail: 'Lorem qui do ea culpa in nulla culpa irure excepteur ad esse. Tempor proident exercitation commodo voluptate consectetur fugiat officia esse mollit est ullamco id. Consectetur velit deserunt velit consectetur eiusmod officia ipsum est ea.',
            profile: 'Docentes de la UTPL'
          ),
          Text('Competencias a desarrollar', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: TextFormats.splitTextIntoLines('''
              Excepteur velit elit mollit eiusmod magna deserunt ex dolor voluptate nulla.
              Nostrud velit duis exercitation sunt anim aliqua ea exercitation nulla Lorem.
              Id sint sint ex reprehenderit irure et nulla adipisicing reprehenderit.
              '''
            ).length,
            itemBuilder: (BuildContext context, int index) {
              final String text = TextFormats.splitTextIntoLines('''
                Excepteur velit elit mollit eiusmod magna deserunt ex dolor voluptate nulla.
                Nostrud velit duis exercitation sunt anim aliqua ea exercitation nulla Lorem.
                Id sint sint ex reprehenderit irure et nulla adipisicing reprehenderit.
                '''
              )[index];

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

  Column buildMainText(context, {required String detail, profile}) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Finalidades de la formación', style: texts.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: responsive.hp(1)),
        Text(detail),
        SizedBox(height: responsive.hp(1)),
        Text('Dirigido a', style: texts.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
        Text(profile),
      ],
    );
  }
}