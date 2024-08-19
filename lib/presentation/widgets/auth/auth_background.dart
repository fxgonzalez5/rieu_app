import 'package:flutter/material.dart';
import 'package:rieu/config/theme/responsive.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Positioned(
          top: responsive.hp(-30),
          child: const _HeaderImage(),
        ),
        Positioned(
          top: responsive.hp(25),
          right: responsive.wp(10),
          child: const _Bubble()
        ),
        Positioned(
          top: responsive.hp(32.5),
          left: responsive.wp(40),
          child: _Bubble(color: colors.primary.withAlpha(75))
        ),
        Positioned(
          top: responsive.hp(33),
          right: responsive.wp(7.5),
          child: _Bubble(size: responsive.ip(1))
        ),
        Positioned(
          top: responsive.hp(45),
          left: responsive.wp(10),
          child: const _Bubble()
        ),
        Positioned(
          top: responsive.hp(52),
          left: responsive.wp(17.5),
          child: _Bubble(size: responsive.ip(1))
        ),
        child
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  final double? size;
  final Color? color;

  const _Bubble({
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

class _HeaderImage extends StatelessWidget {
  const _HeaderImage();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;

    return ClipOval(
      child: Container(
        width: responsive.wp(100),
        height: responsive.hp(60),
        padding: EdgeInsets.only(bottom: responsive.hp(1)),
        alignment: Alignment.bottomCenter,
        color: colors.primary.withAlpha(25),
        child: Image.asset(
          'assets/images/logo_ascendere.png',
          height: responsive.hp(27.5),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}