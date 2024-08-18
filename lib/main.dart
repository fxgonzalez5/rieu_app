import 'package:flutter/material.dart';
import 'package:rieu/config/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Name App',
      home: const Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
      theme: AppTheme().getTheme(context),
    );
  }
}
