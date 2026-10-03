import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'create_drive_screen.dart';
import 'edit_profile_screen.dart';
import 'impact_detail_screen.dart';
import 'manage_drive_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';
import 'splash_onboarding_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = MockDataService().userProfile;
    final isNgo = user.isNgo;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: AppColors.surface,
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.eco, color: AppColors.primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  'ReLeaf',
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isNgo
                        ? AppColors.primaryContainer.withValues(alpha: 0.12)
                        : AppColors.secondarySage.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isNgo ? 'NGO PORTAL' : 'FIELD STEWARD',
                    style: AppTypography.labelMd.copyWith(
                      color: isNgo
                          ? AppColors.primaryContainer
                          : AppColors.secondarySage,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // Notifications Icon
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppColors.primary,
                size: 20,
              ),
              tooltip: 'Notifications',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                );
              },
            ),
            // Settings Icon
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: AppColors.primary, size: 20),
              tooltip: 'Settings and Preferences',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. User Bio & Avatar (Screen 16 & link to 17)
                  _buildBioSection(context, user),

                  const SizedBox(height: 24),

                  // 2. Row of 3 Stat Cards
                  _buildStatsSection(user),

                  const SizedBox(height: 24),

                  // 3. "Your Impact" Section (clickable -> Screen 18 Impact Detail)
                  _buildImpactCard(context, user),

                  const SizedBox(height: 24),

                  // NGO Quick Actions (if NGO user role)
                  if (isNgo) ...[
                    _buildNgoActionsSection(context),
                    const SizedBox(height: 24),
                  ],

                  // 4. "Drive History" Section
                  _buildHistorySection(user),

                  const SizedBox(height: 24),

                  // 5. Account Actions (Log Out)
                  _buildAccountActions(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBioSection(BuildContext context, UserProfile user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceContainer,
            border: Border.all(color: AppColors.outlineVariant, width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          child: user.avatarUrl.isNotEmpty
              ? Image.network(
                  user.avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Center(
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.secondarySage,
                    ),
                  ),
                )
              : const Center(
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.secondarySage,
                  ),
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: AppTypography.headlineSm.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.roleLabel,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.secondarySage,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => const EditProfileScreen(),
                        ),
                      )
                      .then((_) => setState(() {}));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: AppColors.primaryContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Edit Profile',
                      style: AppTypography.labelMd.copyWith(
                        color: AppColors.primaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(UserProfile user) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            stat: user.drivesJoined.toString(),
            label: 'DRIVES JOINED',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statCard(
            stat: user.plantsContributed.toString(),
            label: 'PLANTS CONTRIBUTED',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _statCard(
            stat: user.volunteerHours.toString(),
            label: 'VOLUNTEER HOURS',
          ),
        ),
      ],
    );
  }

  Widget _statCard({required String stat, required String label}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              stat,
              style: AppTypography.headlineXl.copyWith(
                color: AppColors.primaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.labelMd.copyWith(
              color: AppColors.secondarySage,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard(BuildContext context, UserProfile user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'YOUR IMPACT',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.secondarySage,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Sentinel-2 Telemetry',
                style: AppTypography.labelMd.copyWith(color: AppColors.outline),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ImpactDetailScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primaryContainer, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            user.canopyDelta,
                            style: AppTypography.headlineXl.copyWith(
                              color: AppColors.tertiaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'CANOPY DELTA',
                              style: AppTypography.labelMd.copyWith(
                                color: AppColors.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white70,
                      size: 14,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  user.canopySubtext,
                  style: AppTypography.bodySm.copyWith(color: AppColors.surface),
                ),
                const SizedBox(height: 14),
                const Divider(color: Color(0x4D3F665C), height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.satellite_alt,
                            size: 16,
                            color: AppColors.secondaryFixed,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              user.verificationBadge,
                              style: AppTypography.labelMd.copyWith(
                                color: AppColors.secondaryFixed,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'View Proof →',
                      style: AppTypography.labelMd.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNgoActionsSection(BuildContext context) {
    final drives = MockDataService().allDrives;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
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
                  'ORGANIZED RESTORATION PARCELS',
                  style: AppTypography.labelMd.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondarySage,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'NGO Dashboard',
                style: AppTypography.labelMd.copyWith(
                  color: AppColors.outline,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Create Drive'),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CreateDriveScreen(),
                      ),
                    ).then((_) => setState(() {}));
                  },
                ),
              ),
              if (drives.isNotEmpty) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 8,
                      ),
                      side: const BorderSide(color: AppColors.primaryContainer),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    icon: const Icon(Icons.people_outline, size: 16),
                    label: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Manage Roster'),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ManageDriveScreen(drive: drives.first),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(UserProfile user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DRIVE HISTORY (${user.history.length})',
          style: AppTypography.labelMd.copyWith(
            color: AppColors.secondarySage,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.outlineVariant, width: 1),
          ),
          child: Column(
            children: List.generate(user.history.length, (index) {
              final drive = user.history[index];
              final isLast = index == user.history.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                drive.title,
                                style: AppTypography.bodyMd.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${drive.date} • ${drive.plants} saplings • ${drive.hours} hrs',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.secondarySage,
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'VERIFIED',
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.primaryContainer,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      color: AppColors.outlineVariant,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.outlineVariant, width: 1),
          foregroundColor: AppColors.alertDegraded,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: AppColors.surfaceContainerLowest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: const Text('Log Out of ReLeaf?'),
              content: const Text(
                'You will need to request a one-time email passcode to log back in.',
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
                    MockDataService().logout();
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const SplashOnboardingScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text('Log Out'),
                ),
              ],
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 16),
            const SizedBox(width: 8),
            Text(
              'Log Out',
              style: AppTypography.labelLg.copyWith(
                color: AppColors.alertDegraded,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
