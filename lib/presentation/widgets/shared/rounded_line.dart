import 'package:flutter/material.dart';

class RoundedLine extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;

  const RoundedLine({
    super.key,
    required this.width,
    required this.height,
    this.color = Colors.black
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height)
        ),
      ),
    );
  }
}