import 'package:flutter/material.dart';
import 'package:rieu/config/theme/responsive.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final int currentCategory;
  final ValueChanged<String>? onTap;

  const CategoryFilter({
    super.key,
    required this.categories,
    this.currentCategory = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) { 
    return Expanded(
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Align(
          alignment: Alignment.topCenter,
          child: CategoryButton(
            active: index == currentCategory,
            title: categories[index],
            onPressed: onTap,
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final bool active;
  final String title;
  final ValueChanged<String>? onPressed;

  const CategoryButton({
    super.key,
    required this.active,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
      child: FilledButton(
        style: buildButtonStyle(colors, responsive, active: active),
        onPressed: () => onPressed?.call(title),
        child: Text(title),
      ),
    );
  }

  ButtonStyle buildButtonStyle(ColorScheme colors, Responsive responsive, {bool active = false}) {
    return ButtonStyle(
      backgroundColor: active 
        ? WidgetStatePropertyAll(colors.secondary)
        : WidgetStatePropertyAll(Colors.grey.shade100),
      foregroundColor: active 
        ? const WidgetStatePropertyAll(Colors.black) 
        : const WidgetStatePropertyAll(Colors.grey),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          vertical: responsive.hp(2),
          horizontal: responsive.wp(10),
        ),
      ),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontSize: responsive.ip(1.4),
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}