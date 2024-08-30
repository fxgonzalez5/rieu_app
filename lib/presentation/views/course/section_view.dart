import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:rieu/config/helpers/text_formats.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/widgets/widgets.dart';

class SectionView extends StatelessWidget {
  final bool isActive;

  const SectionView({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final sections = [
      {
        'title': 'Introducción a la programación',
        'content': '''
          Excepteur velit elit mollit eiusmod magna deserunt ex dolor voluptate nulla.
          Nostrud velit duis exercitation sunt anim aliqua ea exercitation nulla Lorem.
          Id sint sint ex reprehenderit irure et nulla adipisicing reprehenderit.
          '''
      },
      {
        'title': 'Introducción a la programación',
        'content': null
      },
      {
        'title': 'Introducción a la programación',
        'content': '''
          Excepteur velit elit mollit eiusmod magna deserunt ex dolor voluptate nulla.
          Nostrud velit duis exercitation sunt anim aliqua ea exercitation nulla Lorem.
          Id sint sint ex reprehenderit irure et nulla adipisicing reprehenderit.
          '''
      },
      {
        'title': 'Introducción a la programación',
        'content': '''
          Excepteur velit elit mollit eiusmod magna deserunt ex dolor voluptate nulla.
          Nostrud velit duis exercitation sunt anim aliqua ea exercitation nulla Lorem.
          Id sint sint ex reprehenderit irure et nulla adipisicing reprehenderit.
          '''
      },
    ];
    final responsive = Responsive(context);

    if (sections.length == 1) {
      return Column(
        children: [
          Expanded(child: SectionContent(section: sections[0])),
          if (isActive) SizedBox(height: responsive.hp(10)),
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(child: _SectionList(sections: sections)),
          if (isActive) SizedBox(height: responsive.hp(10)),
        ],
      );
    }
  }
}

class _SectionList extends StatefulWidget {
  final List<Map<String, String?>> sections;

  const _SectionList({
    required this.sections,
  });

  @override
  State<_SectionList> createState() => _SectionListState();
}

class _SectionListState extends State<_SectionList> {
  late List<ExpandableController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.sections.length,
      (_) => ExpandableController(),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
      itemCount: widget.sections.length,
      itemBuilder: (context, index) {
        final bool isLast = index + 1 == widget.sections.length;
        final bool isExpanded = controllers[index].expanded;
        final bool hasContent = widget.sections[index]['content'] != null;
    
        return ExpandableNotifier(
          controller: controllers[index],
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : responsive.hp(1)),
            child: ScrollOnExpand(
              scrollOnCollapse: false,
              child: CustomExpandable(
                controller: controllers[index],
                theme: ExpandableThemeData(
                  animationDuration: hasContent ? null : const Duration(milliseconds: 1),
                ),
                collapsed: Collapsed(
                  decoration: buildDecorationCollapsed(context, isExpanded, hasContent),
                  title: 'Unidad ${index + 1}: ${widget.sections[index]['title']}',
                  titleStyle: isExpanded ? texts.bodyLarge!.copyWith(fontWeight: FontWeight.bold) : null,
                  onExpansionChanged: (value) => setState(() {
                    for (int i = 0; i < controllers.length; i++) {
                      controllers[i].expanded = (i == index) ? value : false;
                    }
                  }),
                ),
                expanded: hasContent
                  ? Container(
                      margin: EdgeInsets.only(bottom: responsive.hp(2)),
                      padding: EdgeInsets.symmetric(vertical: responsive.hp(1), horizontal: responsive.wp(2)),
                      decoration: buildDecorationExpanded(context),
                      child: Builder(
                        builder: (_) {
                          final List<String> listOfContents = TextFormats.splitTextIntoLines(widget.sections[index]['content']!);
                          return Column(
                            children: List.generate(listOfContents.length, (int index) {
                              final text = listOfContents[index];
                              return ListItem(text: text);
                            }),
                          );
                        }
                      ),
                    )
                  : const SizedBox()
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration buildDecorationExpanded(BuildContext context) {
    final responsive = Responsive(context);

    return BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      border: Border.all(width: responsive.ip(0.2)),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(responsive.ip(1))),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 5,
          offset: Offset(0, 5),
        )
      ],
    );
  }

  BoxDecoration buildDecorationCollapsed(BuildContext context, bool isExpanded, bool hasContent) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;

    return BoxDecoration(
      color: isExpanded ? colors.primaryContainer.withAlpha(75) : Colors.grey.shade300,
      border: isExpanded
        ? Border(
            top: BorderSide(width: responsive.ip(0.2)),
            left: BorderSide(width: responsive.ip(0.2)),
            right: BorderSide(width: responsive.ip(0.2)),
            bottom: hasContent ? BorderSide.none : BorderSide(width: responsive.ip(0.2)),
          )
        : null,
      borderRadius: isExpanded 
        ? BorderRadius.vertical(
          top: Radius.circular(responsive.ip(1)),
          bottom: hasContent ? Radius.zero : Radius.circular(responsive.ip(1))
        ) 
        : BorderRadius.circular(responsive.ip(1)),
    );
  }
}

class SectionContent extends StatelessWidget {
  final Map<String, String?> section;

  const SectionContent({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final List<String> listOfContents = TextFormats.splitTextIntoLines(section['content']!);

    return ListView(
      padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
      children: [
        Text(section['title']!, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: responsive.hp(1)),
        ...List.generate(listOfContents.length, (int index) {
          final text = listOfContents[index];
          return ListItem(text: text);
        })
      ],
    );
  }
}
