import 'package:flutter/material.dart';

import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'main_shell_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String selectedRole;

  const ProfileSetupScreen({
    super.key,
    required this.selectedRole,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Aditi Sharma');
  String _selectedChapter = 'Western Ghats Chapter';
  bool _locationGranted = true;
  int _selectedAvatarIndex = 0;

  final List<String> _chapters = [
    'Western Ghats Chapter',
    'Pune & Sahyadri Foothills',
    'Mulshi Catchment Alliance',
    'Deccan Plateau Basin',
    'Konkan Riparian Network',
  ];

  final List<String> _avatars = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAbXpqa5m9gq4Os5CQq3NEHC8DKGBnfnyLtfoFWMeqJKRq3mS2R9T68YWnb87pMci22-z6KhVM_gqZwro4Tb5xRIuFYKaOfqBQdUehZnP-AzIjOkYsaClI7m9B8Vk_hSzykC9msuOfMsvuO-9EpAP5X9woZ9XTm1NHzJbY3WbainTXD2_ftuBCuxRzEepvYZPucLydNxA8kq0e4RsWyNoCuSV91QmzPfVTCn5BuCieJvSzci7vy5Y4mvA',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
  ];

  void _completeSetup() {
    final mockService = MockDataService();
    mockService.updateProfile(
      name: _nameController.text.trim().isEmpty
          ? 'Field Steward'
          : _nameController.text.trim(),
      chapter: _selectedChapter,
      avatarUrl: _avatars[_selectedAvatarIndex],
      role: widget.selectedRole,
      roleLabel: widget.selectedRole == 'ngo'
          ? 'Restoration Coordinator • $_selectedChapter'
          : 'Field Volunteer • $_selectedChapter',
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShellScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'STEP 2 OF 2 // BIODATA SETUP',
              style: AppTypography.labelMd.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Setup',
                    style: AppTypography.headlineLg.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Set up your steward credentials and region to connect with nearby watershed operations.',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Avatar Selection
                  Text(
                    'FIELD BADGE / AVATAR',
                    style: AppTypography.labelMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(_avatars.length, (index) {
                      final isSelected = _selectedAvatarIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedAvatarIndex = index);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 14),
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryContainer
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: AppColors.surfaceContainerHighest,
                            backgroundImage: NetworkImage(_avatars[index]),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 24),

                  // Full Name Field
                  Text(
                    'FULL NAME OR CALLSIGN',
                    style: AppTypography.labelMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: AppTypography.bodyMd,
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      filled: true,
                      fillColor: AppColors.surfaceContainerLowest,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: AppColors.outlineVariant,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: AppColors.outlineVariant,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: AppColors.primaryContainer,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Chapter Dropdown
                  Text(
                    'REGIONAL STEWARD CHAPTER',
                    style: AppTypography.labelMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColors.outlineVariant,
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedChapter,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.onSurfaceVariant,
                        ),
                        items: _chapters.map((chapter) {
                          return DropdownMenuItem(
                            value: chapter,
                            child: Text(chapter, style: AppTypography.bodyMd),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedChapter = val);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Location Permission Prompt Card
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
                        Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer
                                    .withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.my_location,
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
                                    'Geospatial Telemetry Access',
                                    style: AppTypography.titleSm.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  Text(
                                    'Prioritize restoration plots nearest to your GPS coordinates',
                                    style: AppTypography.bodySm.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _locationGranted ? 'ENABLED (PILOT REGION)' : 'OFFLINE',
                              style: AppTypography.labelMd.copyWith(
                                color: _locationGranted
                                    ? AppColors.primaryContainer
                                    : AppColors.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Switch(
                              value: _locationGranted,
                              activeThumbColor: AppColors.primaryContainer,
                              onChanged: (val) {
                                setState(() => _locationGranted = val);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                        foregroundColor: AppColors.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: _completeSetup,
                      child: Text(
                        'Complete Setup & Enter ReLeaf',
                        style: AppTypography.labelLg.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
