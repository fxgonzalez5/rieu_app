import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rieu/config/theme/responsive.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  void onItemTapped( BuildContext context, int index ) {
    switch(index) {
      case 0:
        context.go('/home/0');
        break;
      
      case 1:
        context.go('/home/1');
        break;

      case 2:
        context.go('/home/2');
        break;

      case 3:
        context.go('/home/3');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final colors = Theme.of(context).colorScheme;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: colors.primary,
      iconSize: responsive.ip(3),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black45,
      showUnselectedLabels: false,
      elevation: 0,
      currentIndex: currentIndex,
      onTap: (value) => onItemTapped(context, value),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'Mis Cursos'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Información'
        ),
      ],
    );
  }
}