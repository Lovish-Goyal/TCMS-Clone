import 'package:flutter/material.dart';
import 'router.dart';
import 'shared/theme/theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SEMS',
      restorationScopeId: 'app',
      debugShowCheckedModeBanner: false,
      theme: SEMSTheme.lightThemeData(),
      darkTheme: SEMSTheme.darkThemeData(),
      routerConfig: AppRouter.router,
    );
  }
}
