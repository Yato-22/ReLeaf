import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Status Badges adhering to DESIGN.md
class StatusBadge extends StatelessWidget {
  final String label;
  final PriorityTier tier;
  final bool showDot;

  const StatusBadge({
    super.key,
    required this.label,
    required this.tier,
    this.showDot = true,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color textColor;

    switch (tier) {
      case PriorityTier.low:
        borderColor = AppColors.primaryContainer;
        textColor = AppColors.primaryContainer;
        break;
      case PriorityTier.medium:
        borderColor = AppColors.tertiaryContainer;
        textColor = const Color(0xFF8A6F16);
        break;
      case PriorityTier.high:
        borderColor = AppColors.alertDegraded;
        textColor = AppColors.alertDegraded;
        break;
    }

    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.canvasGray,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: borderColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              label.toUpperCase(),
              style: AppTypography.labelMd.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
