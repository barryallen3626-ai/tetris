import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_screen.dart';

/// Root application widget configuring theme and primary entry route.
class NeonStackApp extends StatelessWidget {
  const NeonStackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
