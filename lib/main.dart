import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/utils/shared_prefs_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences before launching the application
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const NeonStackApp(),
    ),
  );
}
