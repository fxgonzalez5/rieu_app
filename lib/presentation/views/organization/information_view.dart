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
    final texts = Theme.of(context).textTheme;
    final organizationsProfiles = context.read<OrganizationsProvider>().organizationsProfiles;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            collapsedHeight: responsive.hp(20),
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
              title: Center(
                child: Row(
                  children: [
                    Text('Más ', style: texts.headlineLarge,),
                    Text('Información', style: texts.headlineLarge!.copyWith(color: Colors.grey),),
                  ],
                ),
              ),
              background: const _SliverAppBarBackground()
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
            sliver: SliverList.separated(
              itemCount: organizationsProfiles.length,
              separatorBuilder: (_, __) =>  Padding(
                padding: EdgeInsets.symmetric(vertical: responsive.hp(0.75)),
                child: RoundedLine(
                  width: double.infinity,
                  height: responsive.hp(0.25),
                  color: Colors.grey.shade300,
                ),
              ),
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
          )
        ],
      )
    );
  }
}

class _SliverAppBarBackground extends StatelessWidget {
  const _SliverAppBarBackground();

  @override
  Widget build(BuildContext context) {
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;

    return DecoratedBox(
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
    );
  }
}