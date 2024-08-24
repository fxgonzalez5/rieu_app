import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rieu/config/firebase/firebase_options.dart';
import 'package:rieu/config/router/app_router.dart';
import 'package:rieu/config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
