import 'package:flutter/material.dart';

import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late String _selectedChapter;
  late String _selectedRole;
  late String _avatarUrl;
  bool _isSaving = false;

  final List<String> _chapters = [
    'Western Ghats Chapter',
    'Pune & Sahyadri Foothills',
    'Mulshi Catchment Alliance',
    'Deccan Plateau Basin',
    'Konkan Riparian Network',
  ];

  @override
  void initState() {
    super.initState();
    final profile = MockDataService().userProfile;
    _nameController = TextEditingController(text: profile.name);
    _selectedChapter = _chapters.contains(profile.chapter)
        ? profile.chapter
        : _chapters.first;
    _selectedRole = profile.role;
    _avatarUrl = profile.avatarUrl;
  }

  void _saveProfile() {
    setState(() => _isSaving = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _isSaving = false);

      final service = MockDataService();
      final isNgo = _selectedRole.toLowerCase() == 'ngo';
      service.updateProfile(
        name: _nameController.text.trim(),
        chapter: _selectedChapter,
        role: _selectedRole,
        roleLabel: isNgo
            ? 'Restoration Coordinator • $_selectedChapter'
            : 'Field Volunteer • $_selectedChapter',
        avatarUrl: _avatarUrl,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile changes updated successfully.'),
          backgroundColor: AppColors.primaryContainer,
        ),
      );

      Navigator.of(context).pop();
    });
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'EDIT PROFILE CREDENTIALS',
          style: AppTypography.labelMd.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Update Personal Details',
                    style: AppTypography.headlineLg.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Modify your public steward name, avatar, and assigned regional chapter.',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Avatar
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surfaceContainerHighest,
                            border: Border.all(
                              color: AppColors.outlineVariant,
                              width: 1,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _avatarUrl.isNotEmpty
                              ? Image.network(
                                  _avatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 44,
                                      color: AppColors.secondarySage,
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 44,
                                    color: AppColors.secondarySage,
                                  ),
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Name
                  Text(
                    'FULL NAME',
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
                      filled: true,
                      fillColor: AppColors.surfaceContainerLowest,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: AppColors.outlineVariant),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(color: AppColors.outlineVariant),
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
                    'REGIONAL CHAPTER',
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
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedChapter,
                        isExpanded: true,
                        items: _chapters.map((c) {
                          return DropdownMenuItem(
                            value: c,
                            child: Text(c, style: AppTypography.bodyMd),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedChapter = val);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Switch Role Option (Volunteer vs NGO)
                  Text(
                    'OPERATIONAL ROLE',
                    style: AppTypography.labelMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.outlineVariant),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _selectedRole == 'ngo'
                                ? 'Restoration NGO Coordinator'
                                : 'Field Volunteer',
                            style: AppTypography.bodyMd.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: _selectedRole == 'ngo',
                          activeThumbColor: AppColors.primaryContainer,
                          onChanged: (isNgo) {
                            setState(() {
                              _selectedRole = isNgo ? 'ngo' : 'volunteer';
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Save Button
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
                      onPressed: _isSaving ? null : _saveProfile,
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Save Changes',
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
