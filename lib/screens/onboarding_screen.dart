/// Modern onboarding screen matching axiom_onboarding_screen Stitch design
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
    ),
    const OnboardingPage(
      title: 'Infinite\nCreativity',
      description:
          'Draw connections between ideas on an unlimited canvas with powerful thinking tools.',
      iconData: Icons.draw_outlined,
    ),
    const OnboardingPage(
      title: 'Calculate\nEverything',
      description:
          'Built-in computation engine lets you perform complex calculations right where you think.',
      iconData: Icons.functions,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AxiomColors.backgroundDark,
      body: Stack(
        children: [
          // Ambient background glows
          Positioned(
            top: -size.height * 0.1,
            left: -size.width * 0.2,
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return Container(
                  width: size.width * 1.4,
                  height: size.height * 0.6,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AxiomColors.accentTeal.withValues(
                          alpha: 0.15 + _glowController.value * 0.05,
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: -size.height * 0.1,
            right: -size.width * 0.1,
            child: AnimatedBuilder(
              animation: _glowController,
              builder: (context, child) {
                return Container(
                  width: size.width * 0.8,
                  height: size.height * 0.4,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AxiomColors.primary.withValues(
                          alpha: 0.05 + _glowController.value * 0.03,
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

                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: index == _currentPage ? 32 : 6,
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? AxiomColors.primary
                              : Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: index == _currentPage
                              ? [
                                  BoxShadow(
                                    color: AxiomColors.primary.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Get Started Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _handleGetStarted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AxiomColors.primary,
                        foregroundColor: AxiomColors.backgroundDark,
                        elevation: 8,
                        shadowColor: AxiomColors.primary.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AxiomRadius.large,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage < _pages.length - 1
                                ? 'Next'
                                : 'Get Started',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: AxiomColors.backgroundDark,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
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
    super.key,
  });

  final String title;
  final String description;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),

        // Icon/Illustration
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AxiomColors.primary.withValues(alpha: 0.1),
                Colors.transparent,
              ],
            ),
          ),
          child: Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AxiomColors.surfaceDark,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AxiomColors.primary.withValues(alpha: 0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(iconData, size: 60, color: AxiomColors.primary),
            ),
          ),
        ),

        const SizedBox(height: 64),

        // Title
        Text(
          title,
          textAlign: TextAlign.center,
          style: AxiomTypography.h1.copyWith(
            fontSize: 40,
            height: 1.1,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 24),

        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: AxiomTypography.body1.copyWith(
              fontSize: 18,
              height: 1.5,
              color: AxiomColors.textSecondary,
            ),
          ),
        ),

        const Spacer(),
      ],
    );
  }
}
