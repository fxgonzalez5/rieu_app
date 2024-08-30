import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:rieu/config/theme/responsive.dart';

class Collapsed {
  /// Determina si se debe usar [GestureDetector] para efectos de toque.
  /// 
  /// Por defecto es `false`.
  /// 
  /// Se establece automáticamente en `true` si se proporciona
  /// un [trailing] personalizado.
  final bool useGestureDetector;
  final Decoration? decoration;
  final String title;
  final TextStyle? titleStyle;

  /// Un widget para mostrar después del título.
  /// 
  /// Por defecto es un [Icon].
  /// 
  /// Si se desea cambiar el icono a mostrar, debe modificarse los parámetros
  /// [collapseIcon] y [expandIcon] en lugar de este.
  /// 
  /// Se debe tener en cuenta que cuando se modifique este parámetro,
  /// automáticamente el [useGestureDetector] tendrá un valor de `true`.
  final Widget? trailing;
  final IconData? collapseIcon, expandIcon;
  final Color? iconColor;
  final ValueChanged<bool>? onExpansionChanged;

  Collapsed({
    bool? useInkWell,
    this.decoration,
    required this.title,
    this.titleStyle,
    this.trailing,
    this.collapseIcon,
    this.expandIcon,
    this.iconColor,
    required this.onExpansionChanged,
  }) : useGestureDetector = useInkWell ?? (trailing != null);
}


class CustomExpandable extends StatelessWidget {
  final ExpandableController controller;
  final ExpandableThemeData? theme;
  final Collapsed collapsed;
  final Widget expanded;

  const CustomExpandable({
    super.key,
    required this.controller,
    this.theme,
    required this.collapsed,
    required this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    return Expandable(
      controller: controller,
      theme: theme,
      collapsed: buildCollapsed(),
      expanded: Column(
        children: [
          buildCollapsed(),
          expanded,
        ],
      ), 
    );
  }

  Widget buildCollapsed() {
    return _ExpandableTitle(
      useGestureDetector: collapsed.useGestureDetector,
      isExpanded: controller.expanded,
      decoration: collapsed.decoration,
      title: collapsed.title,
      titleStyle: collapsed.titleStyle,
      trailing: collapsed.trailing,
      collapseIcon: collapsed.collapseIcon ?? Icons.expand_more_rounded,
      expandIcon: collapsed.expandIcon ?? Icons.expand_less_rounded,
      iconColor: collapsed.iconColor,
      onTap: collapsed.onExpansionChanged != null 
        ? () => collapsed.onExpansionChanged!(!controller.expanded) 
        : null,
      onPressed: collapsed.onExpansionChanged != null
        ? () => collapsed.onExpansionChanged!(!controller.expanded)
        : null,
    );
  }
}

class _ExpandableTitle extends StatelessWidget {
  final bool useGestureDetector, isExpanded;
  final Decoration? decoration;
  final String title;
  final TextStyle? titleStyle;
  final Widget? trailing;
  final IconData collapseIcon, expandIcon;
  final Color? iconColor;
  final VoidCallback? onTap, onPressed;

  const _ExpandableTitle({
    required this.useGestureDetector,
    required this.isExpanded,
    this.decoration,
    required this.title,
    this.titleStyle,
    this.trailing,
    required this.collapseIcon,
    required this.expandIcon,
    this.iconColor,
    this.onTap,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return GestureDetector(
      onTap: useGestureDetector ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: responsive.hp(1), horizontal: responsive.wp(2)),
        decoration: decoration,
        child: Row(
          children: [
            Expanded(child: Text(title, style: titleStyle ?? Theme.of(context).textTheme.bodyLarge, maxLines: 2)),
            trailing ?? IconButton(
              style: const ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStatePropertyAll(Colors.transparent), 
              ),
              icon: Icon(isExpanded ? expandIcon : collapseIcon),
              color: iconColor ?? Theme.of(context).colorScheme.primary,
              iconSize: responsive.ip(3),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}