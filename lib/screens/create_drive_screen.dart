import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CreateDriveScreen extends StatefulWidget {
  const CreateDriveScreen({super.key});

  @override
  State<CreateDriveScreen> createState() => _CreateDriveScreenState();
}

class _CreateDriveScreenState extends State<CreateDriveScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController(
    text: 'Pashan Lake Catchment Re-wilding',
  );
  final TextEditingController _locationController = TextEditingController(
    text: 'Pashan Reservoir Basin, Pune',
  );
  final TextEditingController _meetingPointController = TextEditingController(
    text: 'Nature Trailhead Gate 2',
  );
  final TextEditingController _coordinatesController = TextEditingController(
    text: '18.5362° N, 73.7845° E',
  );
  final TextEditingController _quotaController = TextEditingController(
    text: '45',
  );
  final TextEditingController _saplingsController = TextEditingController(
    text: '400',
  );
  final TextEditingController _descriptionController = TextEditingController(
    text:
        'Wetland buffer and contour trenching session focusing on stabilizing lakeshore bank erosion using native ficus and bamboo clusters.',
  );

  String _selectedAreaId = 'mulshi-watershed';
  String _dateTimeText = 'Sat, 18 Nov • 07:00 AM';
  String _dateBadge = '18 Nov';
  bool _isPublishing = false;

  void _publishDrive() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isPublishing = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isPublishing = false);

      final service = MockDataService();
      final linkedArea = service.getAreaById(_selectedAreaId);

      final newDrive = RestorationDrive(
        id: 'drive-${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        locationName: _locationController.text.trim(),
        sectorTag: linkedArea?.sector.split('•').first.trim() ?? 'Sector 18B',
        linkedAreaId: _selectedAreaId,
        dateTime: _dateTimeText,
        dateBadge: _dateBadge,
        ngoName: service.userProfile.chapter.isNotEmpty
            ? service.userProfile.chapter
            : 'Western Ghats Ecological Trust',
        isNgoVerified: true,
        volunteersRegistered: 0,
        volunteersCapacity: int.tryParse(_quotaController.text) ?? 40,
        nativePlantsTarget: int.tryParse(_saplingsController.text) ?? 300,
        priorityScore: linkedArea?.priorityScore ?? 75,
        priorityLevel:
            linkedArea?.tier == PriorityTier.high ? 'High' : 'Medium',
        recommendedIntervention: linkedArea?.recommendedActionTitle ??
            'Erosion Control & Enrichment Planting',
        description: _descriptionController.text.trim(),
        meetingPoint: _meetingPointController.text.trim(),
        coordinates: _coordinatesController.text.trim(),
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCXgqxz2NyYtP4uwu7R0ISK1OJuLyTgLXU8u0UFZmyqM05s8uP7mrfhNm0baiJdZIXj3hCMWIt5zG2BLHJ5TBeOz9QLnRsLb8l6X2bTtNcIJt87Kn_hfBrayx4EiSYUIsAHKtPOGGldCgWtkwxzbD78UJVsH4o92BoCMTVyucXfZx5w9YwKlnLGgHu_4MM0xrfmcMMZisn8HcdyV27n8gFmRF5VbNO3oG9_YBcPnkgtzzqXqjT08N2AAA',
      );

      service.createDrive(newDrive);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Restoration drive "${newDrive.title}" published!'),
          backgroundColor: AppColors.primaryContainer,
        ),
      );

      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _meetingPointController.dispose();
    _coordinatesController.dispose();
    _quotaController.dispose();
    _saplingsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final areas = MockDataService().allAreas;

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
          'NGO PORTAL // CREATE DRIVE',
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
              constraints: const BoxConstraints(maxWidth: 540),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Publish Restoration Drive',
                      style: AppTypography.headlineLg.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Target degraded catchments with community volunteers and track certified planting quotas.',
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Drive Title
                    _buildFieldLabel('DRIVE TITLE'),
                    TextFormField(
                      controller: _titleController,
                      style: AppTypography.bodyMd,
                      decoration: _inputDecoration('e.g. Sinhagad Ridge Planting'),
                      validator: (v) => v?.isEmpty == true ? 'Title is required' : null,
                    ),

                    const SizedBox(height: 18),

                    // Linked Area Dropdown
                    _buildFieldLabel('LINKED DEGRADED WATERSHED AREA'),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedAreaId,
                          isExpanded: true,
                          items: areas.map((area) {
                            return DropdownMenuItem(
                              value: area.id,
                              child: Text(
                                '${area.name} (Score ${area.priorityScore})',
                                style: AppTypography.bodyMd,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedAreaId = val);
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Location Name
                    _buildFieldLabel('PARCEL LOCATION / REGION'),
                    TextFormField(
                      controller: _locationController,
                      style: AppTypography.bodyMd,
                      decoration: _inputDecoration('e.g. Sinhagad Ridge, Pune'),
                      validator: (v) => v?.isEmpty == true ? 'Location required' : null,
                    ),

                    const SizedBox(height: 18),

                    // Meeting Point & Coordinates
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('MEETING POINT'),
                              TextFormField(
                                controller: _meetingPointController,
                                style: AppTypography.bodyMd,
                                decoration: _inputDecoration('Basecamp 2'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('COORDINATES'),
                              TextFormField(
                                controller: _coordinatesController,
                                style: AppTypography.bodyMd,
                                decoration: _inputDecoration('18.36° N, 73.75° E'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Date & Time Picker
                    _buildFieldLabel('DATE & FIELD TIME'),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_dateTimeText, style: AppTypography.bodyMd),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _dateTimeText = 'Sun, 26 Nov • 06:30 AM';
                                _dateBadge = '26 Nov';
                              });
                            },
                            child: const Text('Change Date'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Volunteer Quota & Native Saplings Target
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('VOLUNTEER QUOTA'),
                              TextFormField(
                                controller: _quotaController,
                                keyboardType: TextInputType.number,
                                style: AppTypography.bodyMd,
                                decoration: _inputDecoration('50'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('SAPLING TARGET'),
                              TextFormField(
                                controller: _saplingsController,
                                keyboardType: TextInputType.number,
                                style: AppTypography.bodyMd,
                                decoration: _inputDecoration('500'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Description
                    _buildFieldLabel('FIELD BRIEFING & LOGISTICS DESCRIPTION'),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      style: AppTypography.bodyMd,
                      decoration: _inputDecoration(
                        'Outline tool availability, terrain difficulty, and sapling species.',
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Publish Button
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
                        onPressed: _isPublishing ? null : _publishDrive,
                        child: _isPublishing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.publish, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Publish Restoration Drive',
                                    style: AppTypography.labelLg.copyWith(
                                      color: AppColors.onPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
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
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: AppTypography.labelMd.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
    );
  }
}
