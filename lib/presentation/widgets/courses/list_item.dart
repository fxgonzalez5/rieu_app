import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final int? number;
  final String bullet, text;

  const ListItem({
    super.key,
    this.number,
    this.bullet = '-',
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        number != null
          ? Text('$number. ')
          : Text('$bullet '),
        Expanded(
          child: Text(text),
        ),
      ],
    );
  }
}