import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class ManageDriveScreen extends StatefulWidget {
  final RestorationDrive drive;

  const ManageDriveScreen({
    super.key,
    required this.drive,
  });

  @override
  State<ManageDriveScreen> createState() => _ManageDriveScreenState();
}

class _ManageDriveScreenState extends State<ManageDriveScreen> {
  late List<VolunteerRegistration> _roster;

  @override
  void initState() {
    super.initState();
    _loadRoster();
  }

  void _loadRoster() {
    final service = MockDataService();
    final regs = service.registrations
        .where((r) => r.driveId == widget.drive.id)
        .toList();
    if (regs.isEmpty) {
      // Seed default sample roster for manage screen
      _roster = [
        VolunteerRegistration(
          id: 'reg-sample-1',
          driveId: widget.drive.id,
          userName: 'Aditi Sharma',
          userRole: 'Sapling Steward',
          status: 'Checked In',
          registeredAt: 'Today',
        ),
        VolunteerRegistration(
          id: 'reg-sample-2',
          driveId: widget.drive.id,
          userName: 'Rahul Deshmukh',
          userRole: 'Erosion Lead',
          status: 'Checked In',
          registeredAt: 'Yesterday',
        ),
        VolunteerRegistration(
          id: 'reg-sample-3',
          driveId: widget.drive.id,
          userName: 'Priya Patil',
          userRole: 'Field Volunteer',
          status: 'Pending',
          registeredAt: '2 days ago',
        ),
        VolunteerRegistration(
          id: 'reg-sample-4',
          driveId: widget.drive.id,
          userName: 'Amit Joshi',
          userRole: 'Hydration Crew',
          status: 'Pending',
          registeredAt: '2 days ago',
        ),
      ];
    } else {
      _roster = regs;
    }
  }

  void _toggleAttendance(int index) {
    setState(() {
      final current = _roster[index];
      final newStatus = current.status == 'Checked In' ? 'Pending' : 'Checked In';
      _roster[index] = current.copyWith(status: newStatus);
    });
    MockDataService().updateRegistrationStatus(
      _roster[index].id,
      _roster[index].status,
    );
  }

  void _markAllCheckedIn() {
    setState(() {
      _roster = _roster.map((r) => r.copyWith(status: 'Checked In')).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All volunteers marked Checked In.'),
        backgroundColor: AppColors.primaryContainer,
      ),
    );
  }

  void _closeDrive() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(
          'Close Drive & Certify Telemetry?',
          style: AppTypography.titleMd.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Closing this drive finalizes volunteer attendance, locks the parcel manifest, and initiates orbital canopy recovery logging.',
          style: AppTypography.bodyMd,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.alertDegraded,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              MockDataService().closeDrive(widget.drive.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Drive closed & certified successfully.'),
                  backgroundColor: AppColors.primaryContainer,
                ),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Confirm Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkedInCount =
        _roster.where((r) => r.status == 'Checked In').length;

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
          'MANAGE DRIVE // NGO ROSTER',
          style: AppTypography.labelMd.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: AppColors.primaryContainer),
            tooltip: 'Export Manifest CSV',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Volunteer manifest exported to CSV')),
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
                    widget.drive.title,
                    style: AppTypography.headlineLg.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.drive.locationName} • ${widget.drive.dateTime}',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quota Overview Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(
                          'REGISTERED',
                          '${widget.drive.volunteersRegistered}',
                        ),
                        Container(
                          width: 1,
                          height: 36,
                          color: AppColors.outlineVariant,
                        ),
                        _buildStatColumn('CHECKED IN', '$checkedInCount'),
                        Container(
                          width: 1,
                          height: 36,
                          color: AppColors.outlineVariant,
                        ),
                        _buildStatColumn(
                          'CAPACITY',
                          '${widget.drive.volunteersCapacity}',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Volunteer Roster Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'VOLUNTEER ROSTER (${_roster.length})',
                        style: AppTypography.labelMd.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: _markAllCheckedIn,
                        child: Text(
                          'Mark All Present',
                          style: AppTypography.labelMd.copyWith(
                            color: AppColors.primaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Volunteer Cards
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _roster.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final reg = _roster[index];
                      final isCheckedIn = reg.status == 'Checked In';

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isCheckedIn
                                ? AppColors.primaryContainer.withValues(alpha: 0.5)
                                : AppColors.outlineVariant,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: isCheckedIn
                                  ? AppColors.primaryContainer.withValues(alpha: 0.15)
                                  : AppColors.surfaceContainerHighest,
                              child: Text(
                                reg.userName.isNotEmpty
                                    ? reg.userName[0].toUpperCase()
                                    : 'V',
                                style: AppTypography.titleSm.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isCheckedIn
                                      ? AppColors.primaryContainer
                                      : AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reg.userName,
                                    style: AppTypography.titleSm.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${reg.userRole} • ${reg.registeredAt}',
                                    style: AppTypography.bodySm.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _toggleAttendance(index),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isCheckedIn
                                      ? AppColors.primaryContainer
                                      : AppColors.surface,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: isCheckedIn
                                        ? AppColors.primaryContainer
                                        : AppColors.outlineVariant,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isCheckedIn
                                          ? Icons.check
                                          : Icons.schedule,
                                      size: 14,
                                      color: isCheckedIn
                                          ? Colors.white
                                          : AppColors.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isCheckedIn ? 'Checked In' : 'Pending',
                                      style: AppTypography.labelMd.copyWith(
                                        color: isCheckedIn
                                            ? Colors.white
                                            : AppColors.onSurfaceVariant,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Close Drive Button
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.alertDegraded,
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: _closeDrive,
                      child: Text(
                        'Close Drive & Finalize Impact',
                        style: AppTypography.labelLg.copyWith(
                          color: AppColors.alertDegraded,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.labelMd.copyWith(
            fontSize: 9,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.headlineSm.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryContainer,
          ),
        ),
      ],
    );
  }
}
