import 'package:flutter/material.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/widgets/widgets.dart';


class InformationView extends StatelessWidget {
  const InformationView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: responsive.hp(75),
                child: ListView.separated(
                  padding: EdgeInsets.only(top: responsive.hp(3)),
                  itemCount: 5,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (BuildContext _, int index) {
                    return const InfoTile(
                      image: 'assets/images/logo_proyecto_ascendere.png',
                      title: 'Proyecto Ascendere',
                      subTitle: '"Recuerda Superarte Siempre"',
                      link: 'https://flutter.dev',
                    );
                  },
                ),
              ),
            ),
            const _Headline(),
          ],
        ),
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final texts = Theme.of(context).textTheme;

    return Container(
      height: responsive.hp(20),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scaffoldColor,
            scaffoldColor.withOpacity(0.9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.7, 1]
        )
      ),
      child: Row(
        children: [
          Text('Más ', style: texts.displaySmall,),
          Text('Información', style: texts.displaySmall!.copyWith(color: Colors.grey),),
        ],
      )
    );
  }
}