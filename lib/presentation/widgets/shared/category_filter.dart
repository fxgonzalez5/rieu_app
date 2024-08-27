import 'package:flutter/material.dart';
import 'package:rieu/config/theme/responsive.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final int selectedCategory;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) { 
    return Expanded(
      child: ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Align(
          alignment: Alignment.topCenter,
          child: CategoryButton(
            id: index,
            active: index == selectedCategory,
            title: categories[index],
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final int id;
  final bool active;
  final String title;

  const CategoryButton({
    super.key,
    required this.id,
    required this.active,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: responsive.wp(3)),
      child: FilledButton(
        style: buildButtonStyle(colors, responsive, active: active),
        onPressed: !active 
          ? null
          : () {},
        child: Text(title),
      ),
    );
  }

  ButtonStyle buildButtonStyle(ColorScheme colors, Responsive responsive, {bool active = false}) {
    return ButtonStyle(
      backgroundColor: active 
        ? WidgetStatePropertyAll(colors.secondary)
        : const WidgetStatePropertyAll(Color(0xFFF8F2F2)),
      foregroundColor: active ? const WidgetStatePropertyAll(Colors.black) : null,
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