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
    initialLocation: '/',
    redirect: (context, state) {
      // Redirect logic based on app state
      final path = state.matchedLocation;
      
      // If on splash, let it proceed
      if (path == '/splash') return null;
      
      // If onboarding and not on welcome screen, redirect to welcome
      if (isOnboarding && path != '/welcome') {
        return '/welcome';
      }
      
      // If not onboarding but no active workspace, redirect to dashboard
      if (!isOnboarding && activeWorkspaceId == null && path == '/') {
        return '/dashboard';
      }
      
      return null;
    },
    routes: [
      // Splash Screen (app startup)
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Welcome/Onboarding Screen
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
          // This will be redirected by the redirect logic above
          return const SizedBox.shrink();
        },
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.toString() ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodyMedium,
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
