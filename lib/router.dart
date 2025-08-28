import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sems/auth/views/admin_resgister.dart';
import 'package:sems/auth/views/role_selection_signin.dart';
import 'package:sems/features/attendance/views/attendance.dart';
import 'package:sems/features/home/home_screen.dart';
import 'package:sems/features/notifications/notifications_screen.dart';
import 'package:sems/features/batches/add_new_batch.dart';
import 'package:sems/features/teachers/views/bottom_navbar.dart';
import 'package:sems/features/teachers/views/profile/profile_view.dart';
import 'features/admin/views/bottom_dashboard.dart';
import 'auth/views/admin_google_login.dart';
import 'auth/views/student_login.dart';
import 'features/onboarding/introduction_screen.dart';
import 'features/onboarding/spash_screen.dart';
import 'features/scanner/qr_scanner.dart';
import 'features/student/views/active_students_list.dart';

// Keep only the necessary routes
enum AppRoute {
  splash('/'),
  home('/home'),
  roleSelection('/role-selection'),
  studentHome('/student-home'),
  studentLogin('/studentLogin'),
  scanner('/scanner'),
  welcome('/welcome'),
  notifications('/notifications'),
  activeStudentsList('/active-students-list'),
  register('/register'),
  teacherHome('/teacher-home'),
  teacherProfile('/teacher-profile'),
  teacherLogin('/teacher-login'),
  attendance('/teachers'),
  createBatch('/create-batch');

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
        path: AppRoute.teacherLogin.path,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoute.teacherHome.path,
        builder: (context, state) => TeacherBottomBar(),
      ),
      GoRoute(
        path: AppRoute.teacherProfile.path,
        builder: (context, state) => TeacherProfileScreen(),
      ),
      GoRoute(
        path: AppRoute.attendance.path,
        builder: (context, state) => AttendanceScreen(),
      ),
      GoRoute(
        path: AppRoute.createBatch.path,
        builder: (context, state) => BatchScreen(),
      ),
      GoRoute(
        path: AppRoute.home.path,
        builder: (context, state) {
          return const MyAppBottomBar();
        },
      ),
      GoRoute(
        path: AppRoute.studentHome.path,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoute.notifications.path,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoute.activeStudentsList.path,
        builder: (context, state) => const ActiveStudentsList(),
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
