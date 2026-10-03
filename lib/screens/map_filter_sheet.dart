import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/mock_data_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class MapFilterSheet extends StatefulWidget {
  final VoidCallback onFiltersApplied;

  const MapFilterSheet({
    super.key,
    required this.onFiltersApplied,
  });

  @override
  State<MapFilterSheet> createState() => _MapFilterSheetState();
}

class _MapFilterSheetState extends State<MapFilterSheet> {
  PriorityTier? _selectedTier;
  String? _selectedIntervention;
  double _maxDistance = 50.0;
  bool _anyDistance = true;

  final List<String> _interventions = [
    'All',
    'Erosion Control',
    'Assisted Natural Regeneration',
    'Canopy Protection',
    'Riparian Buffer',
  ];

  @override
  void initState() {
    super.initState();
    final service = MockDataService();
    _selectedTier = service.filterTier;
    _selectedIntervention = service.filterIntervention ?? 'All';
    if (service.filterMaxDistanceKm != null) {
      _maxDistance = service.filterMaxDistanceKm!;
      _anyDistance = false;
    }
  }

  void _apply() {
    final service = MockDataService();
    service.setFilters(
      tier: _selectedTier,
      intervention: _selectedIntervention == 'All' ? null : _selectedIntervention,
      maxDistanceKm: _anyDistance ? null : _maxDistance,
    );
    widget.onFiltersApplied();
    Navigator.of(context).pop();
  }

  void _reset() {
    final service = MockDataService();
    service.resetFilters();
    widget.onFiltersApplied();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grab handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.tune,
                      size: 20,
                      color: AppColors.primaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Filter Watershed Plots',
                      style: AppTypography.titleMd.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _reset,
                  child: Text(
                    'Reset All',
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.alertDegraded,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Priority Level
            Text(
              'RESTORATION PRIORITY TIER',
              style: AppTypography.labelMd.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                _buildTierChip(null, 'All Priorities'),
                _buildTierChip(PriorityTier.high, 'High (>70)'),
                _buildTierChip(PriorityTier.medium, 'Medium (40-70)'),
                _buildTierChip(PriorityTier.low, 'Low (<40)'),
              ],
            ),

            const SizedBox(height: 20),

            // Intervention Type
            Text(
              'RECOMMENDED INTERVENTION',
              style: AppTypography.labelMd.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _interventions.map((type) {
                final isSelected = _selectedIntervention == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  selectedColor: AppColors.primaryContainer,
                  backgroundColor: AppColors.surface,
                  labelStyle: AppTypography.labelMd.copyWith(
                    color: isSelected ? Colors.white : AppColors.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (val) {
                    setState(() => _selectedIntervention = val ? type : 'All');
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Distance Radius
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'DISTANCE FROM MY LOCATION',
                  style: AppTypography.labelMd.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  _anyDistance ? 'Any distance' : 'Within ${_maxDistance.round()} km',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.primaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _maxDistance,
                    min: 10,
                    max: 100,
                    divisions: 9,
                    activeColor: AppColors.primaryContainer,
                    onChanged: (val) {
                      setState(() {
                        _maxDistance = val;
                        _anyDistance = false;
                      });
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _anyDistance = !_anyDistance);
                  },
                  child: Text(
                    _anyDistance ? 'Set Limit' : 'Any',
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Apply CTA Button
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
                onPressed: _apply,
                child: Text(
                  'Apply Filters',
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
    );
  }

  Widget _buildTierChip(PriorityTier? tier, String label) {
    final isSelected = _selectedTier == tier;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primaryContainer,
      backgroundColor: AppColors.surface,
      labelStyle: AppTypography.labelMd.copyWith(
        color: isSelected ? Colors.white : AppColors.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (val) {
        setState(() => _selectedTier = val ? tier : null);
      },
    );
  }
}
