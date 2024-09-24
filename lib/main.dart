import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:rieu/config/firebase/firebase_options.dart';
import 'package:rieu/config/router/router.dart';
import 'package:rieu/config/theme/app_theme.dart';
import 'package:rieu/domain/repositories/repositories.dart';
import 'package:rieu/infrastructure/datasources/datasources.dart';
import 'package:rieu/infrastructure/repositories/repositories.dart';
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
        // Lo que hace este provider es que cuando se actualice el AuthProvider, automáticamente se actualice el RouterProvider
        ChangeNotifierProxyProvider<AuthProvider, RouterProvider>(
          create: (context) => RouterProvider(context.read<AuthProvider>()),
          update: (_, authProvider, previous) => previous ?? RouterProvider(authProvider),
        ),
        Provider<GoRouter>(create: (context) => AppRouter(context.read<RouterProvider>()).goRouter, lazy: false),
        Provider<CoursesRepository>(create: (_) => CoursesRepositoryImpl(FirebaseDataSource())),
        Provider<OrganizationsProfilesRepository>(create: (_) => OrganizationsProfilesRepositoryImpl(
          LocalOrganizationsDataSource(jsonPath: 'assets/data/information.json')
        )),
      ],
      child: const MainApp()
    )
  );

}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final coursesRepository = context.read<CoursesRepository>();

    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          // Se sobreentiende que el usuario ya está autenticado y se puede acceder a su información
          create: (context) => UserProvider(userRepository: UserRepositoryImpl(), user: context.read<AuthProvider>().state.user!),
          update: (_, authProvider, previous) {
            if (previous != null && authProvider.state.user! != previous.user) {
              previous.user = authProvider.state.user!;
            }
            return previous ?? UserProvider(userRepository: UserRepositoryImpl(), user: authProvider.state.user!);
          },
        ),
        ChangeNotifierProxyProvider<UserProvider, CoursesProvider>(
          create: (context) => CoursesProvider(coursesRepository: coursesRepository),
          update: (_, userProvider, previous) {
            if (previous != null && userProvider.user.courses.keys.length != previous.userCoursesIds.length) {
              previous.loadUserCourses(userProvider.user.courses.keys.toList());
            }
            return previous ?? CoursesProvider(coursesRepository: coursesRepository);
          },
        ),
        ChangeNotifierProvider(create: (context) => CourseProvider(getCourse: coursesRepository.getCourseById)),
        ChangeNotifierProvider(
          create: (context) => OrganizationsProvider(organizationsRepository: context.read<OrganizationsProfilesRepository>()),
          lazy: false,
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'RIEU',
        routerConfig: context.read<GoRouter>(),
        theme: AppTheme().getTheme(context),
      ),
    );
  }
}
