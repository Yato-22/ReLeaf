import 'package:flutter/material.dart';

import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedTab = 'All';

  @override
  Widget build(BuildContext context) {
    final service = MockDataService();
    final allNotifs = service.notifications;

    final filtered = allNotifs.where((n) {
      if (_selectedTab == 'Drives') return n.type == 'drive';
      if (_selectedTab == 'Telemetry') return n.type == 'satellite';
      return true;
    }).toList();

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
          'FIELD NOTIFICATIONS',
          style: AppTypography.labelMd.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                service.markAllNotificationsRead();
              });
            },
            child: Text(
              'Mark Read',
              style: AppTypography.labelMd.copyWith(
                color: AppColors.primaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Pills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: ['All', 'Drives', 'Telemetry'].map((tab) {
                  final isSelected = _selectedTab == tab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(tab),
                      selected: isSelected,
                      selectedColor: AppColors.primaryContainer,
                      backgroundColor: AppColors.surfaceContainerLowest,
                      labelStyle: AppTypography.labelMd.copyWith(
                        color: isSelected ? Colors.white : AppColors.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (val) {
                        if (val) setState(() => _selectedTab = tab);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // List of Notifications
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_none,
                            size: 48,
                            color: AppColors.outlineVariant,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No notifications in this category',
                            style: AppTypography.bodyMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final notif = filtered[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              service.markNotificationRead(notif.id);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: notif.read
                                  ? AppColors.surfaceContainerLowest
                                  : AppColors.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: notif.read
                                    ? AppColors.outlineVariant
                                    : AppColors.primaryContainer
                                        .withValues(alpha: 0.5),
                                width: notif.read ? 1 : 1.5,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: notif.type == 'drive'
                                        ? AppColors.primaryContainer
                                            .withValues(alpha: 0.1)
                                        : AppColors.tertiaryContainer
                                            .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    notif.type == 'drive'
                                        ? Icons.forest_outlined
                                        : Icons.satellite_alt_outlined,
                                    size: 18,
                                    color: notif.type == 'drive'
                                        ? AppColors.primaryContainer
                                        : AppColors.tertiary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              notif.title,
                                              style: AppTypography.titleSm
                                                  .copyWith(
                                                fontWeight: notif.read
                                                    ? FontWeight.w600
                                                    : FontWeight.bold,
                                                color: AppColors.onSurface,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            notif.timeAgo,
                                            style: AppTypography.bodySm
                                                .copyWith(
                                              fontSize: 10,
                                              color: AppColors.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        notif.message,
                                        style: AppTypography.bodySm.copyWith(
                                          color: AppColors.onSurfaceVariant,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
}
