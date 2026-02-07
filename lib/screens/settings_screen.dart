/// Settings screen - App preferences and configuration
/// Based on Stitch design: settings/code.html
/// Everforest themed with Material 3 Expressive styling.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/design_tokens.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isDarkMode = false;
  bool _canvasGrid = true;
  double _fontSizePercent = 50;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AxiomSpacing.lg,
                  vertical: AxiomSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Appearance section
                    _buildSection(
                      context,
                      title: 'APPEARANCE',
                      children: [
                        _buildSettingsCard(
                          context,
                          children: [
                            _buildToggleRow(
                              context,
                              icon: Icons.dark_mode_rounded,
                              iconBg: cs.primary,
                              title: 'Dark Theme',
                              subtitle: 'Adjust appearance for low light',
                              value: _isDarkMode,
                              onChanged: (val) =>
                                  setState(() => _isDarkMode = val),
                            ),
                            _buildDivider(context),
                            _buildSliderRow(
                              context,
                              icon: Icons.format_size_rounded,
                              iconBg: cs.primary,
                              title: 'Font Size',
                              value: _fontSizePercent,
                              label: '${_fontSizePercent.toInt()}%',
                              onChanged: (val) =>
                                  setState(() => _fontSizePercent = val),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: AxiomSpacing.xl),

                    // Workspace section
                    _buildSection(
                      context,
                      title: 'WORKSPACE',
                      children: [
                        _buildSettingsCard(
                          context,
                          children: [
                            _buildToggleRow(
                              context,
                              icon: Icons.grid_4x4_rounded,
                              iconBg: cs.secondary,
                              title: 'Canvas Grid',
                              subtitle: 'Show dot pattern on canvas',
                              value: _canvasGrid,
                              onChanged: (val) =>
                                  setState(() => _canvasGrid = val),
                            ),
                            _buildDivider(context),
                            _buildActionRow(
                              context,
                              icon: Icons.save_rounded,
                              iconBg: cs.secondary,
                              title: 'Auto-save',
                              subtitle: 'Every 30 seconds',
                              trailing: Text(
                                '30s',
                                style: AxiomTypography.bodySmall.copyWith(
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: AxiomSpacing.xl),

                    // Privacy section
                    _buildSection(
                      context,
                      title: 'PRIVACY & DATA',
                      children: [
                        _buildSettingsCard(
                          context,
                          children: [
                            // Info badge
                            _buildInfoBadge(context),
                            _buildDivider(context),
                            _buildActionRow(
                              context,
                              icon: Icons.file_download_outlined,
                              iconBg: cs.tertiary,
                              title: 'Export Workspace',
                              subtitle: 'Save data to file',
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                color: cs.onSurfaceVariant.withAlpha(100),
                              ),
                            ),
                            _buildDivider(context),
                            _buildActionRow(
                              context,
                              icon: Icons.delete_outline_rounded,
                              iconBg: cs.error,
                              title: 'Clear Cache',
                              subtitle: 'Free up storage space',
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                color: cs.onSurfaceVariant.withAlpha(100),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: AxiomSpacing.xl),

                    // About section
                    _buildSection(
                      context,
                      title: 'ABOUT',
                      children: [
                        _buildSettingsCard(
                          context,
                          children: [
                            _buildActionRow(
                              context,
                              icon: Icons.info_outline_rounded,
                              iconBg: cs.onSurfaceVariant,
                              title: 'Version',
                              subtitle: '0.1.0 (Build 1)',
                              trailing: const SizedBox.shrink(),
                            ),
                            _buildDivider(context),
                            _buildActionRow(
                              context,
                              icon: Icons.bug_report_outlined,
                              iconBg: cs.error,
                              title: 'Report a Bug',
                              subtitle: 'Help us improve',
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                color: cs.onSurfaceVariant.withAlpha(100),
                              ),
                            ),
                            _buildDivider(context),
                            _buildActionRow(
                              context,
                              icon: Icons.description_outlined,
                              iconBg: cs.primary,
                              title: 'Documentation',
                              subtitle: 'Read user guide',
                              trailing: Icon(
                                Icons.chevron_right_rounded,
                                color: cs.onSurfaceVariant.withAlpha(100),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 80), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(
        left: AxiomSpacing.sm,
        right: AxiomSpacing.lg,
        top: AxiomSpacing.md,
        bottom: AxiomSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface, size: 24),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/dashboard');
              }
            },
          ),
          const SizedBox(height: AxiomSpacing.sm),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AxiomSpacing.sm),
            child: Text(
              'Settings',
              style: AxiomTypography.display.copyWith(
                color: cs.onSurface,
                fontSize: 34,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AxiomSpacing.sm,
            bottom: AxiomSpacing.sm,
          ),
          child: Text(
            title,
            style: AxiomTypography.labelSmall.copyWith(
              color: cs.onSurfaceVariant.withAlpha(180),
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AxiomRadius.lg),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildToggleRow(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AxiomSpacing.lg),
      child: Row(
        children: [
          // Icon container
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg.withAlpha(25),
              borderRadius: BorderRadius.circular(AxiomRadius.sm),
            ),
            child: Icon(icon, color: iconBg, size: 22),
          ),
          const SizedBox(width: AxiomSpacing.md),
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AxiomTypography.bodyLarge.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: AxiomTypography.labelSmall.copyWith(
                    color: cs.onSurfaceVariant.withAlpha(150),
                  ),
                ),
              ],
            ),
          ),
          // Switch
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: cs.secondary,
            thumbColor: WidgetStatePropertyAll(Colors.white),
            inactiveThumbColor: cs.onSurfaceVariant,
            inactiveTrackColor: cs.surfaceContainerHigh,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required String title,
    required double value,
    required String label,
    required ValueChanged<double> onChanged,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AxiomSpacing.lg),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg.withAlpha(25),
                  borderRadius: BorderRadius.circular(AxiomRadius.sm),
                ),
                child: Icon(icon, color: iconBg, size: 22),
              ),
              const SizedBox(width: AxiomSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: AxiomTypography.bodyLarge.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                label,
                style: AxiomTypography.bodySmall.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AxiomSpacing.md),
          // Slider with A labels
          Row(
            children: [
              Text(
                'A',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurfaceVariant.withAlpha(120),
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                    ),
                    activeTrackColor: cs.primary,
                    inactiveTrackColor: cs.surfaceContainerHigh,
                    thumbColor: cs.primary,
                    overlayColor: cs.primary.withAlpha(30),
                  ),
                  child: Slider(
                    value: value,
                    min: 0,
                    max: 100,
                    onChanged: onChanged,
                  ),
                ),
              ),
              Text(
                'A',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(AxiomSpacing.lg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg.withAlpha(25),
                borderRadius: BorderRadius.circular(AxiomRadius.sm),
              ),
              child: Icon(icon, color: iconBg, size: 22),
            ),
            const SizedBox(width: AxiomSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AxiomTypography.bodyLarge.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AxiomTypography.labelSmall.copyWith(
                      color: cs.onSurfaceVariant.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AxiomSpacing.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AxiomSpacing.md,
          vertical: AxiomSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: cs.tertiary.withAlpha(20),
          borderRadius: BorderRadius.circular(AxiomRadius.sm),
          border: Border.all(color: cs.tertiary.withAlpha(50), width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.lock_rounded, color: cs.tertiary, size: 18),
            const SizedBox(width: AxiomSpacing.sm),
            Expanded(
              child: Text(
                'All data is stored locally on your device. '
                'No cloud, no tracking.',
                style: AxiomTypography.bodySmall.copyWith(
                  color: cs.tertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AxiomSpacing.lg),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: cs.outlineVariant.withAlpha(60),
      ),
    );
  }
}
