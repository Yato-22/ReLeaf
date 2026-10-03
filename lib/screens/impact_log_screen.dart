import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class ImpactLogScreen extends StatefulWidget {
  final RestorationDrive? drive;

  const ImpactLogScreen({
    super.key,
    this.drive,
  });

  @override
  State<ImpactLogScreen> createState() => _ImpactLogScreenState();
}

class _ImpactLogScreenState extends State<ImpactLogScreen> {
  int _saplings = 12;
  double _hours = 4.0;
  String _selectedSpecies = 'Indigenous Ficus & Jamun';
  final TextEditingController _notesController = TextEditingController();
  bool _photoCaptured = true;
  bool _isSubmitting = false;

  final List<String> _speciesList = [
    'Indigenous Ficus & Jamun',
    'Broadleaf Bamboo & Teak',
    'Wetland Riparian Coir Pouches',
    'Neem & Mahua Saplings',
  ];

  void _submitImpact() {
    setState(() => _isSubmitting = true);

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      final title = widget.drive?.title ?? 'Field Restoration Session';
      MockDataService().logImpact(
        driveTitle: title,
        saplings: _saplings,
        hours: _hours.round(),
        species: _selectedSpecies,
      );

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surfaceContainerLowest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Row(
            children: [
              const Icon(
                Icons.verified,
                color: AppColors.primaryContainer,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Impact Verified',
                style: AppTypography.titleMd.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Your contribution of $_saplings native saplings and ${_hours.toStringAsFixed(1)} field hours has been logged and queued for Sentinel-2 canopy delta verification.',
            style: AppTypography.bodyMd.copyWith(height: 1.4),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.onPrimary,
              ),
              onPressed: () {
                Navigator.of(ctx).pop(); // Close dialog
                Navigator.of(context).pop(); // Close ImpactLogScreen
              },
              child: const Text('Return to Profile'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final driveTitle = widget.drive?.title ?? 'Sinhagad Ridge Reforestation';

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
          'FIELD CHECK-IN // IMPACT LOG',
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
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Record Work Done',
                    style: AppTypography.headlineLg.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Submit sapling counts and volunteer hours to update verified canopy telemetry.',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Drive Identifier Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.outlineVariant,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.forest,
                          color: AppColors.primaryContainer,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ACTIVE RESTORATION DRIVE',
                                style: AppTypography.labelMd.copyWith(
                                  fontSize: 9,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                driveTitle,
                                style: AppTypography.titleSm.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stepper 1: Plants Planted
                  _buildStepperCard(
                    title: 'NATIVE SAPLINGS PLANTED',
                    valueDisplay: '$_saplings saplings',
                    onMinus: () {
                      if (_saplings > 1) setState(() => _saplings -= 1);
                    },
                    onPlus: () {
                      setState(() => _saplings += 1);
                    },
                  ),

                  const SizedBox(height: 16),

                  // Stepper 2: Volunteer Hours
                  _buildStepperCard(
                    title: 'FIELD VOLUNTEER HOURS',
                    valueDisplay: '${_hours.toStringAsFixed(1)} hours',
                    onMinus: () {
                      if (_hours > 0.5) setState(() => _hours -= 0.5);
                    },
                    onPlus: () {
                      setState(() => _hours += 0.5);
                    },
                  ),

                  const SizedBox(height: 20),

                  // Species Select
                  Text(
                    'SPECIES PLANTED',
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
                        value: _selectedSpecies,
                        isExpanded: true,
                        items: _speciesList.map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Text(s, style: AppTypography.bodyMd),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedSpecies = val);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Photo Verification Preview Card
                  Text(
                    'FIELD PHOTO VERIFICATION',
                    style: AppTypography.labelMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() => _photoCaptured = !_photoCaptured);
                    },
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _photoCaptured
                              ? AppColors.primaryContainer
                              : AppColors.outlineVariant,
                          width: 1.5,
                        ),
                      ),
                      child: _photoCaptured
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    widget.drive?.imageUrl ??
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBHkscOaV0TQVfYKHRZKMAVFJq5OxB6Y55ZmxawvWuWC1-1TAaOE83rG96lP445TaCC8t2T4b31rcAsWxCP-QUoy7J9x5fT5fUuZhFchemW0fRM8Dp1XhA11cyrz-OHRYcEwyF1y8Ty5TJzUIANQ7Ej7X3Lf5EXKLLmKbt1M-xq8vz1lvgblbohsyTCrMDsTzPqsgw7il2ByqDczkQxE9ryzyWAINvmu-0sE-FlKbV-zSzWl3DpXUea6Q',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black.withValues(alpha: 0.3),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 12,
                                  right: 12,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'GEO-TAGGED METADATA EMBEDDED',
                                        style: AppTypography.labelMd.copyWith(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 32,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to capture field sapling photo',
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Submit Impact Button
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
                      onPressed: _isSubmitting ? null : _submitImpact,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Submit Impact Log',
                              style: AppTypography.labelLg.copyWith(
                                color: AppColors.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepperCard({
    required String title,
    required String valueDisplay,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.labelMd.copyWith(
                  fontSize: 9,
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valueDisplay,
                style: AppTypography.titleLg.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryContainer,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(color: AppColors.outlineVariant),
                  ),
                ),
                icon: const Icon(Icons.remove, size: 18),
                onPressed: onMinus,
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                icon: const Icon(Icons.add, size: 18),
                onPressed: onPlus,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
