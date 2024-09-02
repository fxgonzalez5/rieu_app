import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rieu/config/theme/responsive.dart';
import 'package:rieu/presentation/providers/providers.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback? searchCallback;

  const CustomSearchBar({
    super.key,
    this.searchCallback,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;
    final coursesProvider = context.read<CoursesProvider>();

    return SearchBar(
      controller: coursesProvider.searchController,
      constraints: BoxConstraints.tightFor(
        height: responsive.hp(5),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.ip(1)),
        ),
      ),
      backgroundColor: WidgetStatePropertyAll(colors.surface),
      hintText: 'Buscar cursos',
      hintStyle: const WidgetStatePropertyAll(TextStyle(color: Colors.grey)),
      onSubmitted: (_) => searchCallback?.call(),
      trailing: [
        IconButton(
          icon: Icon(Icons.search, size: responsive.ip(2.5), color: colors.primary,),
          onPressed: () {
            FocusScope.of(context).unfocus();
            searchCallback?.call();
          },
        ),
      ],
    );
  }
}