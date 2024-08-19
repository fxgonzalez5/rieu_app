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
          top: responsive.hp(45),
          left: responsive.wp(10),
          child: const _Bubble()
        ),
        child
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  final Color? color;

  const _Bubble({
    this.color
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;
    final size = responsive.ip(2);

    return Container(
      width: size,
      height: size,
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