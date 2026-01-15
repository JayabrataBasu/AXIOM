import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'screens/screens.dart';
import 'services/settings_service.dart';
import 'services/canvas_sketch_service.dart';
import 'services/preferences_service.dart';
import 'providers/workspace_state_provider.dart';
import 'providers/workspace_providers.dart';

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
    final activeWorkspaceId = ref.watch(activeWorkspaceIdProvider);

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
      // Route based on onboarding state and active workspace type
      home: isOnboarding
          ? const WelcomeScreen()
          : activeWorkspaceId != null
          ? AppShell(workspaceId: activeWorkspaceId)
          : const WelcomeScreen(),
    );
  }
}

/// App shell that routes to the correct workspace viewer based on session type.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(workspaceSessionProvider(workspaceId));

    return sessionAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error loading workspace: $err')),
      ),
      data: (session) {
        if (session == null) {
          // Workspace was deleted, go back to onboarding
          Future.microtask(() {
            ref.read(activeWorkspaceIdProvider.notifier).clearActive();
          });
          return const Scaffold(
            body: Center(child: Text('Workspace not found')),
          );
        }

        // Route to appropriate workspace viewer based on type
        switch (session.workspaceType) {
          case 'matrix_calculator':
            return WorkspaceShell(sessionId: workspaceId);
          case 'canvas':
          default:
            // Default to canvas screen for regular workspaces
            return const CanvasScreen();
        }
      },
    );
  }
}
