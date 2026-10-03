import 'package:flutter/material.dart';

import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'splash_onboarding_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English';
  String _selectedUnits = 'Metric (Hectares, mm)';
  bool _driveReminders = true;
  bool _satelliteUpdates = true;
  bool _weeklyDigest = false;

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(
          'Delete ReLeaf Account?',
          style: AppTypography.titleMd.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.alertDegraded,
          ),
        ),
        content: Text(
          'All your volunteer attendance history and Sentinel-2 verified certificates will be permanently dissociated from this device.',
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
              MockDataService().logout();
              Navigator.of(ctx).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const SplashOnboardingScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'PREFERENCES & SYSTEM SETTINGS',
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
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Settings',
                    style: AppTypography.headlineLg.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Configure localization, telemetry notification thresholds, and personal data.',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section 1: Localization & Units
                  _buildSectionHeader('LOCALIZATION & MEASUREMENT'),
                  const SizedBox(height: 8),

                  Material(
                    color: AppColors.surfaceContainerLowest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: const BorderSide(color: AppColors.outlineVariant),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Language', style: AppTypography.bodyMd),
                            subtitle: Text(
                              _selectedLanguage,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.primaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.onSurfaceVariant,
                            ),
                            onTap: () {
                              _showLanguageSelector();
                            },
                          ),
                          const Divider(height: 1, color: AppColors.outlineVariant),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text('Measurement Units', style: AppTypography.bodyMd),
                            subtitle: Text(
                              _selectedUnits,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.primaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.onSurfaceVariant,
                            ),
                            onTap: () {
                              _showUnitsSelector();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Section 2: Notifications
                  _buildSectionHeader('TELEMETRY NOTIFICATIONS'),
                  const SizedBox(height: 8),

                  Material(
                    color: AppColors.surfaceContainerLowest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: const BorderSide(color: AppColors.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          activeThumbColor: AppColors.primaryContainer,
                          title: Text(
                            'Drive Reminders & Field Coordinates',
                            style: AppTypography.bodyMd,
                          ),
                          subtitle: Text(
                            'Alerts 24 hours prior to scheduled assembly',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                          value: _driveReminders,
                          onChanged: (v) => setState(() => _driveReminders = v),
                        ),
                        const Divider(height: 1, color: AppColors.outlineVariant),
                        SwitchListTile(
                          activeThumbColor: AppColors.primaryContainer,
                          title: Text(
                            'Satellite Telemetry Passes',
                            style: AppTypography.bodyMd,
                          ),
                          subtitle: Text(
                            'Updates when Sentinel-2 analyzes your planted plots',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                          value: _satelliteUpdates,
                          onChanged: (v) => setState(() => _satelliteUpdates = v),
                        ),
                        const Divider(height: 1, color: AppColors.outlineVariant),
                        SwitchListTile(
                          activeThumbColor: AppColors.primaryContainer,
                          title: Text(
                            'Weekly Western Ghats Digest',
                            style: AppTypography.bodyMd,
                          ),
                          subtitle: Text(
                            'Summary of regional canopy indices and new drives',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                          value: _weeklyDigest,
                          onChanged: (v) => setState(() => _weeklyDigest = v),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Section 3: App Information & Terms
                  _buildSectionHeader('ABOUT & COMPLIANCE'),
                  const SizedBox(height: 8),

                  Material(
                    color: AppColors.surfaceContainerLowest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: const BorderSide(color: AppColors.outlineVariant),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Software Version', style: AppTypography.bodyMd),
                          trailing: Text(
                            'v4.8.1 (Build 120)',
                            style: AppTypography.labelMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const Divider(height: 1, color: AppColors.outlineVariant),
                        ListTile(
                          title: Text('Privacy Policy', style: AppTypography.bodyMd),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: AppColors.onSurfaceVariant,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Opening Privacy Policy')),
                            );
                          },
                        ),
                        const Divider(height: 1, color: AppColors.outlineVariant),
                        ListTile(
                          title: Text('Field Steward Code of Conduct', style: AppTypography.bodyMd),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: AppColors.onSurfaceVariant,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Opening Field Code of Conduct')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Delete Account Action
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
                      onPressed: _deleteAccount,
                      child: Text(
                        'Delete Steward Account',
                        style: AppTypography.labelLg.copyWith(
                          color: AppColors.alertDegraded,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.labelMd.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.onSurfaceVariant,
        fontSize: 10,
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: AppColors.surfaceContainerLowest,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Marathi (मराठी)', 'Hindi (हिंदी)'].map((lang) {
            return ListTile(
              title: Text(lang, style: AppTypography.bodyMd),
              trailing: _selectedLanguage == lang
                  ? const Icon(Icons.check, color: AppColors.primaryContainer)
                  : null,
              onTap: () {
                setState(() => _selectedLanguage = lang);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showUnitsSelector() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        color: AppColors.surfaceContainerLowest,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Metric (Hectares, mm)',
            'Imperial (Acres, inches)',
          ].map((u) {
            return ListTile(
              title: Text(u, style: AppTypography.bodyMd),
              trailing: _selectedUnits == u
                  ? const Icon(Icons.check, color: AppColors.primaryContainer)
                  : null,
              onTap: () {
                setState(() => _selectedUnits = u);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
