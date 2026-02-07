/// Splash screen with animated logo
/// Based on Stitch design: axiom_splash_screen
///
/// Updated for Everforest dark theme with Material 3 Expressive styling.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/design_tokens.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      duration: AxiomDurations.splash,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Start animations
    _controller.forward();

    // Simulate loading progress
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    // Simulate initialization steps
    for (int i = 0; i <= 100; i += 20) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        setState(() {
          _progress = i / 100;
        });
      }
    }

    // Navigate to onboarding after splash
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        context.pushReplacementNamed('onboarding');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Stack(
        children: [
          // Warm parchment/dark background (no grid)
          Positioned.fill(child: Container(color: cs.surface)),

          // Decorative glow circles (soft, organic)
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [cs.primary.withAlpha(15), Colors.transparent],
                ),
              ),
            ),
          ),

          // Main centered content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with subtle pulsing glow
                    _buildLogo(cs),
                    const SizedBox(height: 24),

                    // Progress indicator
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: _buildProgressBar(cs),
                    ),
                    const SizedBox(height: 12),

                    // Status text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: Text(
                            'Initializing...',
                            style: AxiomTypography.labelSmall.copyWith(
                              color: cs.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 60),
                          child: Text(
                            '${(_progress * 100).toStringAsFixed(0)}%',
                            style: AxiomTypography.labelSmall.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom tagline
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Text(
                    'Your private thinking space',
                    style: AxiomTypography.bodySmall.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 2,
                    decoration: BoxDecoration(
                      color: cs.primary.withAlpha(50),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ColorScheme colorScheme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: [
          // Background track
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(30),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          // Animated progress fill
          FractionallySizedBox(
            widthFactor: _progress,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(ColorScheme colorScheme) {
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AxiomRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(60),
            blurRadius: 50,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Outer glow ring (animated)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AxiomRadius.xxl),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary.withAlpha(
                          (60 * _controller.value).round(),
                        ),
                        colorScheme.secondary.withAlpha(
                          (40 * _controller.value).round(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Main logo container
          Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(AxiomRadius.xxl),
              border: Border.all(
                color: colorScheme.outline.withAlpha(50),
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorScheme.surfaceContainer, colorScheme.surface],
              ),
            ),
            child: Center(
              child: Transform.rotate(
                angle: 0.785398, // 45 degrees in radians
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.onSurface.withAlpha(200),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AxiomRadius.md),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.onSurface.withAlpha(40),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
