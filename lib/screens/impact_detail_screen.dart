import 'package:flutter/material.dart';

import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class ImpactDetailScreen extends StatelessWidget {
  const ImpactDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = MockDataService().userProfile;

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
          'VERIFIED SATELLITE IMPACT',
          style: AppTypography.labelMd.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.primaryContainer),
            tooltip: 'Share Impact Certificate',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Impact certificate card copied to clipboard')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
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
                  Text(
                    'Proof of Ecological Yield',
                    style: AppTypography.headlineLg.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Multi-spectral surface reflectance verified by Copernicus Sentinel-2 orbital telemetry.',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Big Impact Hero Certificate Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'SENTINEL-2 CALIBRATED',
                                style: AppTypography.labelMd.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.verified,
                              color: AppColors.tertiaryContainer,
                              size: 22,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          profile.canopyDelta,
                          style: AppTypography.metricDisplay.copyWith(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Average Net Canopy Delta across attended parcels',
                          style: AppTypography.bodySm.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: _buildCertStat(
                                'CONTRIBUTED',
                                '${profile.plantsContributed} saplings',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: _buildCertStat(
                                'VOLUNTEER HOURS',
                                '${profile.volunteerHours} hours',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: _buildCertStat(
                                'DRIVES',
                                '${profile.drivesJoined} joined',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Per-Drive Before/After Recovery Section
                  Text(
                    'PARCEL RECOVERY BREAKDOWN',
                    style: AppTypography.labelMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildDriveRecoveryCard(
                    title: 'Sinhagad Ridge Reforestation',
                    date: 'August 2024 • Sector 04B',
                    baselineNdvi: '0.42',
                    currentNdvi: '0.58 (+38%)',
                    saplings: 18,
                    hours: 4,
                    status: 'Active Biomass Accumulation',
                  ),

                  const SizedBox(height: 12),

                  _buildDriveRecoveryCard(
                    title: 'Mulshi Riparian Buffer Planting',
                    date: 'July 2024 • Sector 18B',
                    baselineNdvi: '0.51',
                    currentNdvi: '0.64 (+25%)',
                    saplings: 24,
                    hours: 5,
                    status: 'Canopy Density Established',
                  ),

                  const SizedBox(height: 12),

                  _buildDriveRecoveryCard(
                    title: 'Pashan Lake Wetland Re-wilding',
                    date: 'June 2024 • Sector 02A',
                    baselineNdvi: '0.62',
                    currentNdvi: '0.71 (+14%)',
                    saplings: 12,
                    hours: 3,
                    status: 'Wetland Margin Stabilized',
                  ),

                  const SizedBox(height: 28),

                  // Telemetry Signature Block
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CRYPTOGRAPHIC VERIFICATION SEAL',
                          style: AppTypography.labelMd.copyWith(
                            fontSize: 9,
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'SHA256: 8f4e92a1c0d5889be094f31c7793d98ba2904e578c7830b12ad75ef1a361093c',
                          style: AppTypography.bodySm.copyWith(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Linked to ESA Open Access Copernicus Hub Data Stream',
                          style: AppTypography.bodySm.copyWith(
                            fontSize: 11,
                            color: AppColors.secondarySage,
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

  Widget _buildCertStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMd.copyWith(
            color: Colors.white70,
            fontSize: 9,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTypography.labelLg.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriveRecoveryCard({
    required String title,
    required String date,
    required String baselineNdvi,
    required String currentNdvi,
    required int saplings,
    required int hours,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleSm.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '+$saplings Trees',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.primaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            date,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PRE-DRIVE BASELINE',
                      style: AppTypography.labelMd.copyWith(
                        fontSize: 9,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'NDVI $baselineNdvi',
                      style: AppTypography.labelLg.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward, size: 16, color: AppColors.outline),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'LATEST ORBIT PASS',
                      style: AppTypography.labelMd.copyWith(
                        fontSize: 9,
                        color: AppColors.primaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'NDVI $currentNdvi',
                      style: AppTypography.labelLg.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 14,
                  color: AppColors.secondarySage,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    status,
                    style: AppTypography.bodySm.copyWith(
                      fontSize: 11,
                      color: AppColors.secondarySage,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
