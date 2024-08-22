import 'package:go_router/go_router.dart';
import 'package:rieu/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/register',
      name: RegisterScreen.name,
      builder: (context, state) => const RegisterScreen(),
    ),

    GoRoute(
      path: '/process-completed',
      name: ProcessCompletedScreen.name,
      builder: (context, state) {
        final extra = state.extra as Map<String, String>;

        return ProcessCompletedScreen(
          title: extra['title'] ?? 'Proceso completado',
          subtitle: extra['subtitle'],
          nextRoute: extra['nextRoute'],
        );
      },
    ),

    GoRoute(
      path: '/',
      redirect: ( _ , __ ) => '/login',
    ),
  ]
);