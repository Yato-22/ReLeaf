import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/telemetry_strip.dart';

class DriveDetailScreen extends StatefulWidget {
  final RestorationDrive drive;

  const DriveDetailScreen({super.key, required this.drive});

  @override
  State<DriveDetailScreen> createState() => _DriveDetailScreenState();
}

class _DriveDetailScreenState extends State<DriveDetailScreen> {
  bool _isJoined = false;

  @override
  Widget build(BuildContext context) {
    final drive = widget.drive;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Top Hero Banner with Back Button
                    _buildHeroBanner(context, drive),

                    // Main Content Canvas
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 580),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title & Organization Block
                              Text(
                                drive.title,
                                style: AppTypography.headlineXlMobile.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  Text(
                                    drive.ngoName,
                                    style: AppTypography.labelLg.copyWith(
                                      color: AppColors.secondarySage,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (drive.isNgoVerified) ...[
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.verified,
                                      size: 16,
                                      color: AppColors.primaryContainer,
                                    ),
                                  ],
                                ],
                              ),

                              const SizedBox(height: 20),

                              // 3 Info Blocks Side-by-Side
                              Row(
                                children: [
                                  Expanded(
                                    child: _infoBlock(
                                      icon: Icons.calendar_today,
                                      value: drive.dateBadge,
                                      label: 'DATE',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _infoBlock(
                                      icon: Icons.group,
                                      value:
                                          '${drive.volunteersRegistered + (_isJoined ? 1 : 0)}/${drive.volunteersCapacity}',
                                      label: 'VOLUNTEERS',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _infoBlock(
                                      icon: Icons.eco_outlined,
                                      value: drive.nativePlantsTarget
                                          .toString(),
                                      label: 'NATIVE PLANTS',
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Cohort Recruitment Telemetry Strip
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'COHORT RECRUITMENT',
                                    style: AppTypography.labelMd.copyWith(
                                      color: AppColors.outline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${((drive.volunteersRegistered + (_isJoined ? 1 : 0)) / drive.volunteersCapacity * 100).round()}% Filled',
                                    style: AppTypography.labelMd.copyWith(
                                      color: AppColors.primaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              TelemetryStrip(
                                value:
                                    (drive.volunteersRegistered +
                                        (_isJoined ? 1 : 0)) /
                                    drive.volunteersCapacity,
                                activeColor: AppColors.primaryContainer,
                                height: 4,
                              ),

                              const SizedBox(height: 24),

                              // Ecological Rationale Section
                              Text(
                                'ECOLOGICAL RATIONALE',
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.outline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildRationaleCard(drive),

                              const SizedBox(height: 24),

                              // Description Section
                              Text(
                                'DESCRIPTION',
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.outline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                drive.description,
                                style: AppTypography.bodyMd.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Meeting Point & Logistics Card
                              Text(
                                'MEETING POINT & LOGISTICS',
                                style: AppTypography.labelMd.copyWith(
                                  color: AppColors.outline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildLogisticsCard(drive),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Pinned Action Bar
            Container(
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                border: Border(
                  top: BorderSide(color: AppColors.surfaceContainer, width: 1),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 580),
                  child: SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isJoined
                            ? AppColors.secondarySage
                            : AppColors.primaryContainer,
                        foregroundColor: AppColors.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isJoined = !_isJoined;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _isJoined
                                  ? 'Registered for ${drive.title}! Check-in coordinates sent.'
                                  : 'Registration cancelled.',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isJoined ? Icons.check : Icons.forest,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isJoined ? 'Registered' : 'Join Drive',
                            style: AppTypography.labelLg.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.bold,
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

  Widget _buildHeroBanner(BuildContext context, RestorationDrive drive) {
    return Container(
      width: double.infinity,
      height: 240,
      color: AppColors.surfaceContainer,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (drive.imageUrl.isNotEmpty)
            Image.network(
              drive.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: const Color(0xFF1B382B),
                child: const Center(
                  child: Icon(Icons.forest, size: 64, color: Colors.white54),
                ),
              ),
            )
          else
            Container(
              color: const Color(0xFF1B382B),
              child: const Center(
                child: Icon(Icons.forest, size: 64, color: Colors.white54),
              ),
            ),

          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.outlineVariant, width: 1),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: AppColors.primaryContainer,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),

          // Zone Sector Tag
          Positioned(
            bottom: 12,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                drive.sectorTag.toUpperCase(),
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBlock({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.surfaceContainerHigh, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.secondarySage),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.labelMd.copyWith(
              color: AppColors.outline,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRationaleCard(RestorationDrive drive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.surfaceContainerHigh, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.analytics_outlined,
                    size: 18,
                    color: AppColors.secondarySage,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Priority Score: ${drive.priorityScore}',
                    style: AppTypography.headlineSm.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.tertiaryContainer,
                    width: 1,
                  ),
                ),
                child: Text(
                  drive.priorityLevel.toUpperCase(),
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.surfaceContainerHigh, height: 1),
          const SizedBox(height: 10),

          Text(
            'RECOMMENDED INTERVENTION',
            style: AppTypography.labelMd.copyWith(
              color: AppColors.secondarySage,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            drive.recommendedIntervention,
            style: AppTypography.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogisticsCard(RestorationDrive drive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.surfaceContainerHigh, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.pin_drop_outlined,
              size: 18,
              color: AppColors.primaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drive.meetingPoint,
                  style: AppTypography.bodyMd.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  drive.coordinates,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.outline,
                    fontFamily: 'monospace',
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
