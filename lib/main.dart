import 'package:flutter/material.dart';

import 'screens/main_shell_screen.dart';
import 'screens/splash_onboarding_screen.dart';
import 'services/mock_data_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MockDataService().init();
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
