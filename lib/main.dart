import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:rieu/config/firebase/firebase_options.dart';
import 'package:rieu/config/router/router.dart';
import 'package:rieu/config/theme/app_theme.dart';
import 'package:rieu/infrastructure/repositories/auth_repository_impl.dart';
import 'package:rieu/presentation/providers/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository: AuthRepositoryImpl())),
        ChangeNotifierProxyProvider<AuthProvider, RouterProvider>(
          create: (context) => RouterProvider(context.read<AuthProvider>()),
          update: (context, authProvider, previous) => previous ?? RouterProvider(authProvider),
        ),
        Provider<GoRouter>(create: (context) => AppRouter(context.read<RouterProvider>()).goRouter, lazy: false),
      ],
      child: const MainApp()
    )
  );
  
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RIEU',
      routerConfig: context.read<GoRouter>(),
      theme: AppTheme().getTheme(context),
    );
  }
}
