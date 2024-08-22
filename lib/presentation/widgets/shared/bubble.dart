import 'package:flutter/material.dart';
import 'package:rieu/config/theme/responsive.dart';

class Bubble extends StatelessWidget {
  final double? size;
  final Color? color;

  const Bubble({
    super.key, 
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: size ?? responsive.ip(2),
      height: size ?? responsive.ip(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: color ?? colors.primary.withAlpha(25)
      ),
    );
  }
}