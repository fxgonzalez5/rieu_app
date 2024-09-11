import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/widgets/widgets.dart';

class ProcessCompletedScreen extends StatelessWidget {
  static const String name = 'process_completed_screen';
  final String title;
  final String? subtitle, nextRoute;

  const ProcessCompletedScreen({super.key,
    required this.title,
    this.subtitle,
    this.nextRoute
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      body: Stack(
        children: [
          ...[
            Positioned(
              top: responsive.hp(33),
              right: responsive.wp(22),
              child: Bubble(size: responsive.ip(0.75))
            ),
            Positioned(
              bottom: responsive.hp(46),
              left: responsive.wp(30),
              child: Bubble(size: responsive.ip(0.75))
            ),
            Positioned(
              bottom: responsive.hp(45),
              right: responsive.wp(7),
              child: Bubble(size: responsive.ip(0.75))
            )
          ].animate(delay: const Duration(milliseconds: 2100)).scale(duration: const Duration(milliseconds: 500), curve: Curves.easeOutCirc),
          
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _CustomAnimate(),
              _Content(caption: title, message: subtitle, route: nextRoute ?? '/'),
            ],
          ),
        ],
      ),
    );
  }
}

class BubbleModel {
  final int anglePosition, durationMilliseconds;
  final double offsetX, offsetY;

  BubbleModel({
    required this.anglePosition,
    required this.durationMilliseconds,
    this.offsetX = 0,
    this.offsetY = 0
  });
}

class _CustomAnimate extends StatefulWidget {
  const _CustomAnimate({
    super.key,
  });

  @override
  State<_CustomAnimate> createState() => _CustomAnimateState();
}

class _CustomAnimateState extends State<_CustomAnimate> with TickerProviderStateMixin {
  final List<BubbleModel> bubbles = [
    BubbleModel(anglePosition: 35, durationMilliseconds: 550),
    BubbleModel(anglePosition: 180, durationMilliseconds: 450, offsetX: -15),
    BubbleModel(anglePosition: 225, durationMilliseconds: 400, offsetX: 30, offsetY: -30),
    BubbleModel(anglePosition: 285, durationMilliseconds: 400, offsetY: -40),
    BubbleModel(anglePosition: 325, durationMilliseconds: 200, offsetX: 75, offsetY: -85),
  ];
  late final List<AnimationController> controllers;
  late final List<Animation<double>> opacityAnimations, angleAnimations;
  late final Animation<double> rightAnimation;

  @override
  void initState() {
    super.initState();
    // Inicializar la lista de los controladores
    controllers = bubbles.map((bubble) => AnimationController(vsync: this, duration: Duration(milliseconds: bubble.durationMilliseconds))).toList();

    startAnimation(0);
  }

  double degreesToRadians(int degrees) => degrees * pi / 180;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final responsive = Responsive(context);
    final radius = min(responsive.ip(15) * 0.5, responsive.ip(15) * 0.5) + responsive.ip(2.5);

    opacityAnimations = List.generate(bubbles.length, (index) => Tween(begin:  0.0, end: 1.0).animate(
      CurvedAnimation(parent: controllers[index], curve: Curves.easeInOut)
    ));

    rightAnimation = Tween(begin: 0.0, end: radius + 30).animate(
      CurvedAnimation(parent: controllers[0], curve: Curves.easeInOutCubic)
    );

    angleAnimations = List.generate(bubbles.length, (index) {
      double begin = index == 0 ? 0 : degreesToRadians(bubbles[index - 1].anglePosition);
      double end = degreesToRadians(bubbles[index].anglePosition);
      
      return Tween(begin: begin, end: end).animate(
        CurvedAnimation(parent: controllers[index], curve: Curves.easeInOut)
      );
    });
  }

  void startAnimation(int index) async {
    if (index < bubbles.length) {
      controllers[index].forward();
      await Future.delayed(Duration(milliseconds: bubbles[index].durationMilliseconds));
      startAnimation(index + 1);
    }
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
    return SizedBox.square(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...List.generate(bubbles.length, (index) => AnimatedBuilder(
              animation: controllers[index],
              child: Bubble(color: index % 2 != 0 ? Theme.of(context).colorScheme.primary.withAlpha(75) : null ),
              builder: (context, child) {
                final bubble = bubbles[index];
                final x = (rightAnimation.value + bubble.offsetX) * cos(angleAnimations[index].value);
                final y = (-rightAnimation.value + bubble.offsetY) * sin(angleAnimations[index].value);
            
                return Transform.translate(
                  offset: Offset(x, y),
                  child: Opacity(
                    opacity: opacityAnimations[index].value,
                    child: child,
                  ),
                );
              },
            )
          ),
    
          Animate(
            delay: const Duration(milliseconds: 2100), // Es la suma del tiempo de las animaciones de las burbujas
            effects: const [ScaleEffect(duration: Duration(milliseconds: 500), curve: Curves.easeOutCirc)],
            child: const _CheckCircle()
          )
        ]  
      ),
    );
  }
}

class _CheckCircle extends StatelessWidget {
  const _CheckCircle();

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      padding: EdgeInsets.all(responsive.ip(2.5)),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(25),
        shape: BoxShape.circle
      ),
      child: Icon(
        Icons.check_circle_outline_rounded,
        size: responsive.ip(15),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final String caption, route;
  final String? message;
  
  const _Content({
    required this.caption,
    this.message,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: responsive.hp(15)),
        Text(caption, style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w600)),
        SizedBox(height: responsive.hp(2.5)),
        if (message != null) SizedBox(
          width: responsive.wp(70),
          child: Text(message!, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
        ),
        SizedBox(height: responsive.hp(5)),
        FilledButton(
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: responsive.hp(2), horizontal: responsive.wp(12))),
          ),
          onPressed: () => context.replace(route),
          child: const Text('Continuar'),
        )
      ].animate(delay: const Duration(milliseconds: 2100)).scale(duration: const Duration(milliseconds: 500), curve: Curves.easeOutCirc),
    );
  }
}