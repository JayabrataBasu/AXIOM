/// Splash screen with animated logo
/// Based on Stitch design: axiom_splash_screen
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

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Start animations
    _controller.forward();
    
    // Simulate loading progress
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    // Simulate initialization steps
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) {
        setState(() {
          _progress = i / 100;
        });
      }
    }
    
    // Navigate to welcome or dashboard after splash
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        context.go('/welcome');
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
    return Scaffold(
      backgroundColor: AxiomColors.backgroundDark,
      body: Stack(
        children: [
          // Background effects
          Positioned.fill(
            child: CustomPaint(
              painter: _GridBackgroundPainter(),
            ),
          ),
          
          // Ambient glow
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.0,
                  colors: [
                    AxiomColors.primary.withAlpha((0.2 * 255).round()),
                    Colors.transparent,
                  ],
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
                    _buildLogo(),
                    const SizedBox(height: AxiomSpacing.xl),
                    
                    // Brand name
                    Text(
                      'AXIOM',
                      style: AxiomTypography.display.copyWith(
                        fontSize: 48,
                        letterSpacing: 8,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AxiomSpacing.md),
                    
                    // Status
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.terminal,
                          size: 14,
                          color: AxiomColors.primary,
                        ),
                        const SizedBox(width: AxiomSpacing.sm),
                        Text(
                          'SYSTEM INITIALIZING',
                          style: AxiomTypography.labelSmall.copyWith(
                            color: AxiomColors.textMuted,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
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
                    'SECURE CONNECTION ESTABLISHED',
                    style: AxiomTypography.labelSmall.copyWith(
                      color: AxiomColors.textSecondary,
                      letterSpacing: 2,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(height: AxiomSpacing.xs),
                  Text(
                    'v0.1.0',
                    style: AxiomTypography.labelSmall.copyWith(
                      color: AxiomColors.textSecondary,
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

  Widget _buildLogo() {
    return Container(
      width: 128,
      height: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AxiomRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: AxiomColors.primary.withAlpha((0.4 * 255).round()),
            blurRadius: 40,
            spreadRadius: -5,
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
                        AxiomColors.primary.withAlpha(
                          ((0.4 * _controller.value * 255)).round(),
                        ),
                        AxiomColors.primaryLight.withAlpha(
                          ((0.4 * _controller.value * 255)).round(),
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
              color: AxiomColors.backgroundDark,
              borderRadius: BorderRadius.circular(AxiomRadius.xxl),
              border: Border.all(
                color: Colors.white.withAlpha((0.1 * 255).round()),
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AxiomColors.primary.withAlpha((0.8 * 255).round()),
                  AxiomColors.backgroundDark,
                ],
              ),
            ),
            child: Center(
              child: Transform.rotate(
                angle: 0.785398, // 45 degrees in radians
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withAlpha((0.8 * 255).round()),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AxiomRadius.md),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withAlpha((0.3 * 255).round()),
                        blurRadius: 15,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.9 * 255).round()),
                        borderRadius: BorderRadius.circular(AxiomRadius.sm),
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

/// Grid background painter
class _GridBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha((0.03 * 255).round())
      ..strokeWidth = 1;

    const gridSize = 40.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
