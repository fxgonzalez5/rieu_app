import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/providers/providers.dart';
import 'package:rieu/presentation/widgets/widgets.dart';

class InformationView extends StatelessWidget {
  const InformationView({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final organizationsProfiles = context.read<OrganizationsProvider>().organizationsProfiles;

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
                  itemCount: organizationsProfiles.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final organizationProfile = organizationsProfiles[index];

                    return InfoTile(
                      image: organizationProfile.imagePath,
                      title: organizationProfile.name,
                      subTitle: organizationProfile.slogan,
                      link: organizationProfile.website,
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