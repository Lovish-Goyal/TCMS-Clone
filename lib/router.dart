import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth/views/login_screen.dart';
import 'features/splash/splash_screen.dart';

// Keep only the necessary routes
enum AppRoute {
  splash('/'),
  login('/login');

  const AppRoute(this.path);
  final String path;
}

class AppRouter {
  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static final GoRouter router = GoRouter(
    navigatorKey: _navigatorKey,
    initialLocation: AppRoute.splash.path,
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoute.login.path,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.error.toString()),
            ElevatedButton(
              onPressed: () => context.go(AppRoute.splash.path),
              child: const Text('Go to Splash'),
            ),
          ],
        ),
      ),
    ),
  );
}
