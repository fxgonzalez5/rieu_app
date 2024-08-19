import 'package:flutter/material.dart';
import 'package:rieu/config/router/app_router.dart';
import 'package:rieu/config/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RIEU',
      routerConfig: appRouter,
      theme: AppTheme().getTheme(context),
    );
  }
}
