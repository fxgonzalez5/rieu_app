import 'package:go_router/go_router.dart';
import 'package:rieu/config/router/router_provider.dart';
import 'package:rieu/presentation/providers/providers.dart';
import 'package:rieu/presentation/screens/screens.dart';

class AppRouter {
  final RouterProvider _routerProvider;

  AppRouter(this._routerProvider);

  GoRouter get goRouter => GoRouter(
    initialLocation: '/',
    refreshListenable: _routerProvider,
    routes: [
      GoRoute(
        path: '/',
        name: CheckAuthScreen.name,
        builder: (context, state) => const CheckAuthScreen(),
      ),

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
            title: extra['title'] ?? 'Proceso Completado',
            subtitle: extra['subtitle'],
            nextRoute: extra['nextRoute'],
          );
        },
      ),

      GoRoute(
        path: '/home',
        name: HomeScreen.name,
        builder: (context, state) => const HomeScreen(),
      ),
    ],

    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = _routerProvider.authStatus;

      if (isGoingTo == '/' && authStatus == AuthStatus.checking) return null;

      if (authStatus == AuthStatus.unauthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;
        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/' || isGoingTo == '/login') return '/home';
        return null;
      }

      return null;
    },
  );
}