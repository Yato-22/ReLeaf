import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Thin 4px structural horizontal progress and capacity indicators.
/// Defined in DESIGN.md section "Specialized Environmental Telemetry Strips"
class TelemetryStrip extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final Color? activeColor;
  final Color? backgroundColor;
  final double height;

  const TelemetryStrip({
    super.key,
    required this.value,
    this.activeColor,
    this.backgroundColor,
    this.height = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: clamped,
        child: Container(
          decoration: BoxDecoration(
            color: activeColor ?? AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }
}
