import 'package:flutter/material.dart';

import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class MethodologyScreen extends StatelessWidget {
  const MethodologyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final methodology = service.methodology;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'SCIENTIFIC METHODOLOGY',
          style: AppTypography.labelMd.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Meta
                  Text(
                    'Biophysical Scoring & Satellite Telemetry',
                    style: AppTypography.headlineLg.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'MODEL ${methodology?.calibrationVersion ?? 'v4.8.1-sahyadri'}',
                          style: AppTypography.labelMd.copyWith(
                            color: AppColors.primaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Calibrated: ${methodology?.lastUpdated ?? '01 Oct 2026'}',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ReLeaf eliminates arbitrary restoration scoring. Every plot index is derived directly from peer-reviewed earth-observation sensors and biophysical equations.',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Scoring Formula Breakdown
                  Text(
                    'SCORING ALGORITHM & WEIGHT DISTRIBUTION',
                    style: AppTypography.labelMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.outlineVariant,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Priority Index = Σ (Weight_i × Normalized Factor_i)',
                          style: AppTypography.labelLg.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryContainer,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildWeightRow(
                          factor: 'Canopy Density Loss (ΔNDVI)',
                          percent: 40,
                          rationale:
                              'Calculated across 10m Sentinel-2 optical bands comparing pre-monsoon vs dry season baseline.',
                        ),
                        const Divider(height: 20, color: AppColors.outlineVariant),
                        _buildWeightRow(
                          factor: 'Slope Incline & Runoff Gradient',
                          percent: 25,
                          rationale:
                              'Derived from 30m SRTM digital elevation. Exponentially weights steep catchment slopes.',
                        ),
                        const Divider(height: 20, color: AppColors.outlineVariant),
                        _buildWeightRow(
                          factor: 'Topsoil Erosion Loss Rate',
                          percent: 20,
                          rationale:
                              'Universal Soil Loss Equation (USLE) calibrated for Deccan volcanic basalt horizons.',
                        ),
                        const Divider(height: 20, color: AppColors.outlineVariant),
                        _buildWeightRow(
                          factor: 'Monsoon Precipitation Deficit',
                          percent: 15,
                          rationale:
                              'CHIRPS daily anomaly relative to the 30-year regional Western Ghats moving mean.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Data Sources
                  Text(
                    'EARTH OBSERVATION DATA SOURCES',
                    style: AppTypography.labelMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildSourceCard(
                    title: 'ESA Sentinel-2 Multi-Spectral Instrument (MSI)',
                    badge: '10m Optical Resolution',
                    details:
                        'Dual-satellite constellation with 5-day revisit cycle. Bands 4 (665 nm) and 8 (842 nm) are harvested to compute Normalized Difference Vegetation Index (NDVI).',
                    icon: Icons.satellite_alt_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildSourceCard(
                    title: 'NASA Shuttle Radar Topography Mission (SRTM)',
                    badge: '30m Elevation Grid',
                    details:
                        'InSAR radar surface elevation models hydrological flow paths, ridgelines, and gravitational runoff acceleration in high-precipitation microclimates.',
                    icon: Icons.terrain_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildSourceCard(
                    title: 'CHIRPS & IMD Rainfall Observation',
                    badge: '0.05° Gridded Telemetry',
                    details:
                        'Infrared precipitation estimates merged with Indian Meteorological Department ground rain gauges to track root-zone aquifer recharge.',
                    icon: Icons.water_drop_outlined,
                  ),

                  const SizedBox(height: 32),

                  // Trust & Verification Note
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.outlineVariant,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.verified_outlined,
                          color: AppColors.primaryContainer,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Open Environmental Audit Trail',
                                style: AppTypography.titleSm.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Telemetry readings undergo automated radiometric normalization and cloud-masking algorithms before priorities are refreshed in the field app.',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightRow({
    required String factor,
    required int percent,
    required String rationale,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                factor,
                style: AppTypography.titleSm.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$percent%',
                style: AppTypography.labelMd.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          rationale,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSourceCard({
    required String title,
    required String badge,
    required String details,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primaryContainer),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleSm.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: AppColors.outlineVariant, width: 0.8),
            ),
            child: Text(
              badge,
              style: AppTypography.labelMd.copyWith(
                fontSize: 10,
                color: AppColors.primaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            details,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.4,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
