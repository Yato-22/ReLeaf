import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'splash_onboarding_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const user = ReLeafData.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: AppColors.surface,
          title: Row(
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
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.tune, color: AppColors.primary, size: 20),
              tooltip: 'Settings and Tuning',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Field volunteer preferences')),
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
                  // 1. User Bio & Avatar
                  _buildBioSection(context, user),

                  const SizedBox(height: 24),

                  // 2. Row of 3 Stat Cards
                  _buildStatsSection(user),

                  const SizedBox(height: 24),

                  // 3. "Your Impact" Section
                  _buildImpactCard(user),

                  const SizedBox(height: 24),

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
                user.role,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.secondarySage,
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit Profile modal')),
                  );
                },
                child: Text(
                  'Edit Profile',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.secondarySage,
                    fontWeight: FontWeight.bold,
                  ),
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
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            stat,
            style: AppTypography.headlineXl.copyWith(
              color: AppColors.primaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 28,
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
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard(UserProfile user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'YOUR IMPACT',
              style: AppTypography.labelMd.copyWith(
                color: AppColors.secondarySage,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Q3 Baseline',
              style: AppTypography.labelMd.copyWith(color: AppColors.outline),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
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
                  Text(
                    'CANOPY DELTA',
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                user.canopySubtext,
                style: AppTypography.bodySm.copyWith(color: AppColors.surface),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0x4D3F665C), height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.satellite_alt,
                    size: 16,
                    color: AppColors.secondaryFixed,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user.verificationBadge,
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.secondaryFixed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(UserProfile user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Drive History',
              style: AppTypography.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            Text(
              '${user.history.length} Completed',
              style: AppTypography.labelMd.copyWith(
                color: AppColors.secondarySage,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: user.history.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = user.history[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.outlineVariant, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: AppTypography.bodyMd.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.date,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.secondarySage,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (dialogCtx) => AlertDialog(
            title: const Text('Log Out'),
            content: const Text(
              'Are you sure you want to log out of your field session?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                ),
                onPressed: () {
                  Navigator.of(dialogCtx).pop();
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.logout, size: 18, color: AppColors.outline),
            const SizedBox(width: 8),
            Text(
              'Log Out',
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.outline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
