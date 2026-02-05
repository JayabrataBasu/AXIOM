/// Splash screen with animated logo
/// Based on Stitch design: axiom_splash_screen
///
/// Updated for Everforest dark theme with Material 3 Expressive styling.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/design_tokens.dart';
import '../widgets/components/axiom_loading.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AxiomColors.bg0,
      body: Stack(
        children: [
          // Subtle grid background
          Positioned.fill(
            child: CustomPaint(painter: _GridBackgroundPainter()),
          ),

          // Warm ambient glow from top - Everforest green tint
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [
                    AxiomColors.green.withAlpha(25),
                    AxiomColors.aqua.withAlpha(10),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Main content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    _buildLogo(colorScheme),
                    const SizedBox(height: AxiomSpacing.xl),

                    // Brand name - warm cream color from Everforest
                    Text(
                      'AXIOM',
                      style: AxiomTypography.display.copyWith(
                        fontSize: 48,
                        letterSpacing: 8,
                        color: AxiomColors.fg,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: AxiomSpacing.md),

                    // Tagline
                    Text(
                      'A THINKING SYSTEM',
                      style: AxiomTypography.labelSmall.copyWith(
                        color: AxiomColors.grey1,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom section with progress bar
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Progress bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: AxiomProgressBar(value: _progress),
                  ),
                  const SizedBox(height: AxiomSpacing.lg),

                  // Version text
                  Text(
                    'v0.1.0',
                    style: AxiomTypography.labelSmall.copyWith(
                      color: AxiomColors.grey0,
                      fontFamily: 'monospace',
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

  Widget _buildLogo(ColorScheme colorScheme) {
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AxiomRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: AxiomColors.green.withAlpha(60),
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
                        AxiomColors.green.withAlpha(
                          (60 * _controller.value).round(),
                        ),
                        AxiomColors.aqua.withAlpha(
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
              color: AxiomColors.bg0,
              borderRadius: BorderRadius.circular(AxiomRadius.xxl),
              border: Border.all(
                color: AxiomColors.outline.withAlpha(50),
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AxiomColors.bg2, AxiomColors.bg0],
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
                      color: AxiomColors.fg.withAlpha(200),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AxiomRadius.md),
                    boxShadow: [
                      BoxShadow(
                        color: AxiomColors.fg.withAlpha(40),
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
                        color: AxiomColors.green,
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

/// Grid background painter - subtle warm grid
class _GridBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AxiomColors.bg3.withAlpha(20)
      ..strokeWidth = 1;

    const gridSize = 48.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
