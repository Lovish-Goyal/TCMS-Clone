import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sems/auth/views/admin_resgister.dart';
import 'package:sems/auth/views/role_selection_signin.dart';
import 'package:sems/features/home/home_screen.dart';
import 'auth/views/admin_google_login.dart';
import 'auth/views/student_login.dart';
import 'features/onboarding/introduction_screen.dart';
import 'features/onboarding/spash_screen.dart';
import 'features/scanner/qr_scanner.dart';

// Keep only the necessary routes
enum AppRoute {
  splash('/'),
  login('/login'),
  home('/home'),
  roleSelection('/role-selection'),
  studentHome('/student-home'),
  studentLogin('/studentLogin'),
  scanner('/scanner'),
  welcome('/welcome'),
  register('/register');

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
        path: AppRoute.welcome.path,
        builder: (context, state) => const MyIntroductionScreen(),
      ),
      GoRoute(
        path: AppRoute.login.path,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoute.home.path,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoute.studentHome.path,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoute.register.path,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return RegisterScreen(
            uid: extra['uid'],
            email: extra['email'],
            name: extra['name'],
          );
        },
      ),
      GoRoute(
        path: AppRoute.studentLogin.path,
        builder: (context, state) => LoginStudentScreen(),
      ),
      GoRoute(
        path: AppRoute.scanner.path,
        builder: (context, state) => const QrScannerScreen(),
      ),
      GoRoute(
        path: AppRoute.roleSelection.path,
        builder: (context, state) => const RoleSelectionScreen(),
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
