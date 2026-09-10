import 'package:flutter/material.dart';

/// Design tokens and semantic colors for ReLeaf
/// Defined in DESIGN.md
abstract final class AppColors {
  // Brand Primaries
  static const Color primary = Color(0xFF012D1D);
  static const Color primaryContainer = Color(0xFF1B4332); // Deep Forest Green
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF86AF99);
  static const Color primaryFixed = Color(0xFFC1ECD4);
  static const Color primaryFixedDim = Color(0xFFA5D0B9);
  static const Color onPrimaryFixed = Color(0xFF002114);
  static const Color onPrimaryFixedVariant = Color(0xFF274E3D);
  static const Color inversePrimary = Color(0xFFA5D0B9);

  // Secondaries (Sage Green)
  static const Color secondary = Color(0xFF3F665C);
  static const Color secondarySage = Color(0xFF52796F);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFBEE8DC);
  static const Color onSecondaryContainer = Color(0xFF436A60);
  static const Color secondaryFixed = Color(0xFFC1EBDF);
  static const Color secondaryFixedDim = Color(0xFFA6CFC3);

  // Tertiaries (Muted Gold)
  static const Color tertiary = Color(0xFF755B00);
  static const Color tertiaryContainer = Color(0xFFCEA72C);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF4F3D00);
  static const Color tertiaryFixed = Color(0xFFFFE08E);
  static const Color tertiaryFixedDim = Color(0xFFECC246);

  // Alert / Degraded Semantics
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  static const Color alertDegraded = Color(
    0xFF7F2A22,
  ); // Degraded plot, soil toxicity, severe erosion

  // Surfaces & Backgrounds
  static const Color surface = Color(0xFFF8FAF9);
  static const Color surfaceDim = Color(0xFFD8DAD9);
  static const Color surfaceBright = Color(0xFFF8FAF9);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F3);
  static const Color surfaceContainer = Color(0xFFECEEED);
  static const Color surfaceContainerHigh = Color(0xFFE6E9E8);
  static const Color surfaceContainerHighest = Color(0xFFE1E3E2);
  static const Color background = Color(0xFFF8FAF9);
  static const Color canvasGray = Color(0xFFEDEFEE);

  // Text & Ink
  static const Color onSurface = Color(0xFF191C1C);
  static const Color onSurfaceVariant = Color(0xFF414844);
  static const Color textCharcoal = Color(0xFF1F2421);
  static const Color inverseSurface = Color(0xFF2E3131);
  static const Color inverseOnSurface = Color(0xFFEFF1F0);

  // Outlines & Hairlines
  static const Color outline = Color(0xFF717973);
  static const Color outlineVariant = Color(0xFFC1C8C2);
  static const Color hairlineBorder = Color(0xFFE0E3E1);
  static const Color surfaceTint = Color(0xFF3F6653);
}
