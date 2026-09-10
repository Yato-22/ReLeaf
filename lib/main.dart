import 'package:flutter/material.dart';

import 'screens/splash_onboarding_screen.dart';
import 'screens/main_shell_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ReLeafApp());
}

class ReLeafApp extends StatelessWidget {
  const ReLeafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReLeaf — Satellite Intelligence for Ecosystem Restoration',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashOnboardingScreen(),
        '/home': (context) => const MainShellScreen(),
      },
    );
  }
}
