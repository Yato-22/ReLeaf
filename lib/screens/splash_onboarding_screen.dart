import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/contour_leaf_painter.dart';
import 'main_shell_screen.dart';

class SplashOnboardingScreen extends StatelessWidget {
  const SplashOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryContainer,
      body: SafeArea(
        child: Column(
          children: [
            // Top technical metadata bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.tertiaryContainer,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'SYS.SAT-ORBIT // 4.81.0',
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.onPrimaryContainer,
                          letterSpacing: 0.08 * 11,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'CALIBRATED ACTIVE',
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.onPrimaryContainer,
                      letterSpacing: 0.08 * 11,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable central content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Branding & Tagline
                        Row(
                          children: [
                            const Icon(
                              Icons.eco,
                              color: AppColors.onPrimary,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'ReLeaf',
                              style: AppTypography.headlineXl.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Satellite intelligence for ecosystem restoration',
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.primaryFixedDim,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Contour Leaf & Satellite Grid Illustration
                        const Center(child: ContourLeafWidget()),

                        const SizedBox(height: 24),

                        // Explainer Key Points
                        _buildFeatureItem(
                          icon: Icons.radar,
                          title: 'See where restoration is needed most',
                          subtitle: 'Real-time canopy density loss and soil moisture anomalies.',
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureItem(
                          icon: Icons.analytics_outlined,
                          title: 'Understand why, not just a score',
                          subtitle: 'Actionable biophysical telemetry backed by multi-spectral bands.',
                        ),
                        const SizedBox(height: 16),
                        _buildFeatureItem(
                          icon: Icons.forest_outlined,
                          title: 'Join real restoration drives near you',
                          subtitle: 'Coordinate field stewards, track planting parcels, and verify yield.',
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom CTA Container
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surfaceContainerLowest,
                            foregroundColor: AppColors.primaryContainer,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const MainShellScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Get Started',
                            style: AppTypography.labelLg.copyWith(
                              color: AppColors.primaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const MainShellScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Already have an account? Log in',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.surfaceDim,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'FIELD AGENT PROTOCOL // RELEAF BIOSYSTEMS',
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.onPrimaryContainer.withValues(alpha: 0.6),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Icon(icon, color: AppColors.primaryFixed, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
