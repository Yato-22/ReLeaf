import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/telemetry_strip.dart';
import 'create_drive_screen.dart';
import 'drive_detail_screen.dart';

class RestorationDrivesScreen extends StatefulWidget {
  final String? filterAreaId;

  const RestorationDrivesScreen({super.key, this.filterAreaId});

  @override
  State<RestorationDrivesScreen> createState() =>
      _RestorationDrivesScreenState();
}

class _RestorationDrivesScreenState extends State<RestorationDrivesScreen> {
  String _selectedFilter = 'Near me';
  String? _activeAreaFilter;

  @override
  void initState() {
    super.initState();
    _activeAreaFilter = widget.filterAreaId;
  }

  List<RestorationDrive> get _drives {
    var list = MockDataService().allDrives;
    if (_activeAreaFilter != null) {
      list = list.where((d) => d.linkedAreaId == _activeAreaFilter).toList();
    }
    if (_selectedFilter == 'High priority areas') {
      list = list.where((d) => d.priorityScore > 70).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isNgo = MockDataService().userProfile.isNgo;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: isNgo
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: AppColors.onPrimary,
              icon: const Icon(Icons.add),
              label: const Text('Create Drive'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreateDriveScreen()),
                ).then((_) => setState(() {}));
              },
            )
          : null,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: AppColors.surfaceContainerLowest,
          title: Text(
            'Restoration Drives',
            style: AppTypography.headlineLg.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            if (isNgo)
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryContainer),
                tooltip: 'Create New Drive',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CreateDriveScreen()),
                  ).then((_) => setState(() {}));
                },
              ),
            IconButton(
              icon: const Icon(Icons.tune, color: AppColors.outline, size: 20),
              tooltip: 'Filter drives',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Filter options: Date range, Region, Species',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_activeAreaFilter != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.primaryContainer.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppColors.primaryContainer),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Filtered to: ${MockDataService().getAreaById(_activeAreaFilter!)?.name ?? _activeAreaFilter}',
                        style: AppTypography.labelMd.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryContainer,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16, color: AppColors.primaryContainer),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() => _activeAreaFilter = null);
                      },
                    ),
                  ],
                ),
              ),
            ],

            // Horizontal Filter Chips Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                border: Border(
                  bottom: BorderSide(color: Color(0x33C1C8C2), width: 1),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      [
                        'Near me',
                        'This month',
                        'High priority areas',
                        'Native Species',
                      ].map((filter) {
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryContainer
                                    : AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(4),
                                border: isSelected
                                    ? null
                                    : Border.all(
                                        color: AppColors.outlineVariant,
                                        width: 1,
                                      ),
                              ),
                              child: Row(
                                children: [
                                  if (filter == 'Near me') ...[
                                    Icon(
                                      Icons.near_me,
                                      size: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                  Text(
                                    filter.toUpperCase(),
                                    style: AppTypography.labelMd.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.onSurfaceVariant,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),

            // Active Sector Sub-bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 580),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'ACTIVE SECTOR  ',
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.secondarySage,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Maharashtra Zone IV',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${_drives.length} Scheduled',
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.secondarySage,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Drives List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: _drives.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final drive = _drives[index];
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 580),
                      child: _buildDriveCard(context, drive),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriveCard(BuildContext context, RestorationDrive drive) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DriveDetailScreen(drive: drive)),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: drive.imageUrl.isNotEmpty
                      ? Image.network(
                          drive.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Center(
                            child: Icon(
                              Icons.forest,
                              color: AppColors.secondarySage,
                            ),
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.forest,
                            color: AppColors.secondarySage,
                          ),
                        ),
                ),
                const SizedBox(width: 14),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drive.title,
                        style: AppTypography.headlineSm.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.secondarySage,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              drive.locationName,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: AppColors.secondarySage,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            drive.dateTime,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Verified NGO
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 15,
                            color: AppColors.primaryContainer,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              drive.ngoName,
                              style: AppTypography.labelMd.copyWith(
                                color: AppColors.secondarySage,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(color: AppColors.surfaceContainer, height: 1),
            const SizedBox(height: 10),

            // Progress indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PARTICIPATION QUOTA',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.secondarySage,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${drive.volunteersRegistered}/${drive.volunteersCapacity} volunteers',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            TelemetryStrip(
              value: drive.quotaProgress,
              activeColor: AppColors.secondarySage,
              height: 4,
            ),
          ],
        ),
      ),
    );
  }
}
