import 'package:flutter/material.dart';
import 'package:rieu/config/helpers/helpers.dart';
import 'package:rieu/config/theme/responsive.dart';

class InfoTile extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final String linkText;
  final String? link;

  const InfoTile({
    super.key, 
    required this.image,
    required this.title,
    required this.subTitle,
    this.linkText = 'conoce más +',
    this.link,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final texts = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.hp(2)),
      child: Row(
        children: [
          Image.asset(
            image,
            width: responsive.wp(27.5),
            fit: BoxFit.fitWidth,
          ),
          SizedBox(width: responsive.ip(1.5)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: texts.titleSmall,),
                SizedBox(height: responsive.hp(1),),
                Text(subTitle, style: texts.bodyLarge!.copyWith(color: Colors.grey), maxLines: 2,),
                SizedBox(height: responsive.hp(2),),
                TextButton(
                  onPressed: link != null
                    ? () => openUrl(link!)
                    : null,
                  child: Text(linkText, style: const TextStyle(decoration: TextDecoration.underline)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}