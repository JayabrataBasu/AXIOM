import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'screens/screens.dart';
import 'services/settings_service.dart';
import 'services/canvas_sketch_service.dart';
import 'services/preferences_service.dart';
import 'providers/workspace_state_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services asynchronously without blocking UI
  // Services will complete initialization in background
  SettingsService.instance.initialize();
  CanvasSketchService.instance.initialize();
  await PreferencesService.instance.init();

  // Configure window for desktop platforms only
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(1400, 900),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: 'Axiom',
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const ProviderScope(child: AxiomApp()));
}

/// Root application widget for Axiom.
class AxiomApp extends ConsumerWidget {
  const AxiomApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch if user is onboarding (no active workspace)
    final isOnboarding = ref.watch(isOnboardingProvider);

    return MaterialApp(
      title: 'Axiom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D3436),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D3436),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      ),
      // Show welcome screen on first launch, else show canvas
      home: isOnboarding ? const WelcomeScreen() : const CanvasScreen(),
    );
  }
}
