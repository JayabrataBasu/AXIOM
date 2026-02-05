/// Modern onboarding screen matching axiom_onboarding_screen Stitch design
/// Updated for Everforest dark theme with Material 3 Expressive styling.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/design_tokens.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _glowController;

  final List<OnboardingPage> _pages = [
    const OnboardingPage(
      title: 'Master Your\nWorkflow',
      description:
          'Centralize your tools, tasks, and timelines into single, focused workspace sessions.',
      iconData: Icons.layers_outlined,
      accentColor: AxiomColors.green,
    ),
    const OnboardingPage(
      title: 'Infinite\nCreativity',
      description:
          'Draw connections between ideas on an unlimited canvas with powerful thinking tools.',
      iconData: Icons.draw_outlined,
      accentColor: AxiomColors.aqua,
    ),
    const OnboardingPage(
      title: 'Calculate\nEverything',
      description:
          'Built-in computation engine lets you perform complex calculations right where you think.',
      iconData: Icons.functions,
      accentColor: AxiomColors.blue,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _handleGetStarted() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to welcome/workspace creation
      context.go('/welcome');
    }
  }

  Color get _currentAccentColor => _pages[_currentPage].accentColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AxiomColors.bg0,
      body: Stack(
        children: [
          // Animated ambient background glow - follows current page accent
          Positioned(
            top: -size.height * 0.15,
            left: -size.width * 0.3,
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: size.width * 1.6,
                  height: size.height * 0.5,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        _currentAccentColor.withAlpha(
                          (20 + _glowController.value * 15).round(),
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                children: [
                  // Page indicator and content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return _pages[index];
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Page indicators - M3 style pill indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: index == _currentPage ? 32 : 8,
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? _currentAccentColor
                              : AxiomColors.bg4,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: index == _currentPage
                              ? [
                                  BoxShadow(
                                    color: _currentAccentColor.withAlpha(80),
                                    blurRadius: 12,
                                    spreadRadius: 0,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Get Started Button - M3 filled tonal style
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: _handleGetStarted,
                      style: FilledButton.styleFrom(
                        backgroundColor: _currentAccentColor,
                        foregroundColor: AxiomColors.bg0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AxiomRadius.lg),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage < _pages.length - 1
                                ? 'Next'
                                : 'Get Started',
                            style: AxiomTypography.labelLarge.copyWith(
                              color: AxiomColors.bg0,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: AxiomColors.bg0,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Skip button
                  if (_currentPage < _pages.length - 1) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.go('/welcome'),
                      child: Text(
                        'Skip',
                        style: AxiomTypography.labelMedium.copyWith(
                          color: AxiomColors.grey1,
                        ),
                      ),
                    ),
                  ] else
                    const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    required this.title,
    required this.description,
    required this.iconData,
    required this.accentColor,
    super.key,
  });

  final String title;
  final String description;
  final IconData iconData;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),

        // Icon/Illustration - M3 expressive container
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [accentColor.withAlpha(25), Colors.transparent],
            ),
          ),
          child: Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AxiomColors.bg2,
                borderRadius: BorderRadius.circular(AxiomRadius.xl),
                border: Border.all(color: accentColor.withAlpha(60), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withAlpha(40),
                    blurRadius: 40,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Icon(iconData, size: 48, color: accentColor),
            ),
          ),
        ),

        const SizedBox(height: 56),

        // Title - warm cream Everforest foreground
        Text(
          title,
          textAlign: TextAlign.center,
          style: AxiomTypography.display.copyWith(
            fontSize: 36,
            height: 1.1,
            fontWeight: FontWeight.w600,
            color: AxiomColors.fg,
          ),
        ),

        const SizedBox(height: 20),

        // Description - muted grey for soft contrast
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: AxiomTypography.bodyLarge.copyWith(
              fontSize: 16,
              height: 1.6,
              color: AxiomColors.grey1,
            ),
          ),
        ),

        const Spacer(),
      ],
    );
  }
}
