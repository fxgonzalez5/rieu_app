import 'package:flutter/material.dart';
import 'package:rieu/config/theme/responsive.dart';

class BackgroundImages extends StatelessWidget {
  const BackgroundImages({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: responsive.hp(22),
        ),
        Expanded(
          child: Image.asset(
            'assets/images/watermark.png',
            scale: 0.8,
          ),
        ),
        Expanded(
          child: Image.asset(
            'assets/images/watermark.png',
            scale: 0.8,
          ),
        ),
      ]
    );
  }
}