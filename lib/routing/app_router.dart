/// App routing configuration using go_router
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/screens.dart';
import '../providers/workspace_state_provider.dart';
import '../main.dart' show AppShell;

/// Provider for GoRouter instance
final routerProvider = Provider<GoRouter>((ref) {
  final isOnboarding = ref.watch(isOnboardingProvider);
  final activeWorkspaceId = ref.watch(activeWorkspaceIdProvider);

  return GoRouter(
    // Start with splash screen
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen (app startup)
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding Screen (first-time experience)
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Welcome/Workspace Creation Screen
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),

      // Dashboard/Home Screen
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),

      // Workspace Routes
      GoRoute(
        path: '/workspace/:id',
        name: 'workspace',
        builder: (context, state) {
          final workspaceId = state.pathParameters['id']!;
          return AppShell(workspaceId: workspaceId);
        },
        routes: [
          // Node Editor
          GoRoute(
            path: 'node/:nodeId',
            name: 'node-editor',
            builder: (context, state) {
              final nodeId = state.pathParameters['nodeId']!;
              return NodeEditorScreen(nodeId: nodeId);
            },
          ),
        ],
      ),

      // Workspace Sessions List
      GoRoute(
        path: '/workspaces',
        name: 'workspaces',
        builder: (context, state) => const WorkspaceSessionsScreen(),
      ),

      // Root - redirects to appropriate screen
      GoRoute(
        path: '/',
        name: 'root',
        builder: (context, state) {
          // Determine where to go based on app state
          if (isOnboarding) {
            return const WelcomeScreen();
          } else if (activeWorkspaceId != null) {
            return AppShell(workspaceId: activeWorkspaceId);
          } else {
            return const DashboardScreen();
          }
        },
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Navigation Error',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                state.error?.toString() ?? 'Unknown navigation error',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
