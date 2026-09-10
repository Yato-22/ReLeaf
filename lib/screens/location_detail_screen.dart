import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/telemetry_strip.dart';
import 'restoration_drives_screen.dart';

class LocationDetailScreen extends StatelessWidget {
  final PlotLocation location;
  final VoidCallback? onViewDrives;

  const LocationDetailScreen({
    super.key,
    required this.location,
    this.onViewDrives,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: AppColors.surfaceContainerLowest,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.primaryContainer,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          titleSpacing: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                location.name,
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                location.sector,
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.secondarySage,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 580),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Timelapse Panel
                        _buildTimelapseSection(),

                        const SizedBox(height: 16),

                        // 2. Priority Score Card
                        _buildPriorityScoreCard(),

                        const SizedBox(height: 16),

                        // 3. Why this score Section
                        _buildWhyThisScoreSection(),

                        const SizedBox(height: 16),

                        // 4. Recommended Action Card
                        _buildRecommendedActionCard(),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Sticky Bottom Action Bar
            Container(
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                border: Border(
                  top: BorderSide(color: AppColors.outlineVariant, width: 1),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 580),
                  child: SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                        foregroundColor: AppColors.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () {
                        if (onViewDrives != null) {
                          Navigator.of(context).pop();
                          onViewDrives!();
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RestorationDrivesScreen(),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.forest_outlined, size: 18),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'View Nearby Restoration Drives',
                              style: AppTypography.labelLg.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelapseSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'CANOPY LOSS TIMELAPSE',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.secondarySage,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SENTINEL-2 NDVI',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Comparative Panels
          Row(
            children: [
              Expanded(
                child: _timelapseImage(
                  imageUrl: location.beforeImageUrl,
                  yearBadge: '2021',
                  isPristine: true,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _timelapseImage(
                  imageUrl: location.afterImageUrl,
                  yearBadge: '2025',
                  isPristine: false,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: AppColors.surfaceContainer, height: 1),
          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Vegetation Index Delta',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.secondarySage,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Text(
                    location.ndviDeltaText,
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.trending_down,
                    size: 16,
                    color: AppColors.error,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timelapseImage({
    required String imageUrl,
    required String yearBadge,
    required bool isPristine,
  }) {
    return Container(
      height: 128,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imageUrl.isNotEmpty)
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: isPristine
                    ? const Color(0xFF234B36)
                    : const Color(0xFF5C523A),
                child: Center(
                  child: Icon(
                    isPristine ? Icons.forest : Icons.broken_image,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            )
          else
            Container(
              color: isPristine
                  ? const Color(0xFF234B36)
                  : const Color(0xFF5C523A),
              child: Center(
                child: Icon(
                  isPristine ? Icons.forest : Icons.terrain,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isPristine
                    ? AppColors.primaryContainer
                    : AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
                border: isPristine
                    ? null
                    : Border.all(color: AppColors.outlineVariant, width: 0.8),
              ),
              child: Text(
                yearBadge,
                style: AppTypography.labelMd.copyWith(
                  color: isPristine ? AppColors.onPrimary : AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityScoreCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'RESTORATION PRIORITY',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.onPrimaryContainer,
                    letterSpacing: 0.08 * 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'IMMEDIATE ACTION REQUIRED',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.onError,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                location.priorityScore.toString(),
                style: AppTypography.metricDisplay.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '/ 100 Risk Index',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          Text(
            location.description,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onPrimaryContainer,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),

          TelemetryStrip(
            value: location.priorityScore / 100.0,
            activeColor: AppColors.error,
            backgroundColor: AppColors.primary,
            height: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildWhyThisScoreSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why this score',
            style: AppTypography.headlineSm.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          _scoreRow(
            title: 'NDVI change',
            subtitle: '4-year mean spectral decline',
            value: location.ndviChange,
            isNegative: true,
          ),
          const Divider(color: AppColors.surfaceContainer, height: 1),

          _scoreRow(
            title: 'Rainfall anomaly',
            subtitle: 'Deviation from 30-yr baseline',
            value: location.rainfallAnomaly,
            isNegative: true,
          ),
          const Divider(color: AppColors.surfaceContainer, height: 1),

          _scoreRow(
            title: 'Slope',
            subtitle: 'Average terrain inclination',
            value: location.slope,
            icon: Icons.landscape_outlined,
          ),
          const Divider(color: AppColors.surfaceContainer, height: 1),

          _scoreRow(
            title: 'Forest cover change',
            subtitle: 'Net reduction in core biomass',
            value: location.forestCoverChange,
            isNegative: true,
          ),
          const Divider(color: AppColors.surfaceContainer, height: 1),

          _scoreRow(
            title: 'Topsoil loss rate',
            subtitle: 'Estimated RUSLE erosion index',
            value: location.topsoilLossRate,
            icon: Icons.layers_outlined,
          ),
        ],
      ),
    );
  }

  Widget _scoreRow({
    required String title,
    required String subtitle,
    required String value,
    bool isNegative = false,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMd.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.secondarySage,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              Text(
                value,
                style: AppTypography.bodyMd.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isNegative ? AppColors.error : AppColors.onSurface,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                icon ?? Icons.arrow_downward,
                size: 14,
                color: isNegative ? AppColors.error : AppColors.outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedActionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.secondary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified,
                color: AppColors.onSecondaryContainer,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'RECOMMENDED ACTION',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.08 * 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            location.recommendedActionTitle,
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            location.recommendedActionDesc,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSecondaryContainer,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
