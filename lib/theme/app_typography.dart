import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Hanken Grotesk typography system for ReLeaf
abstract final class AppTypography {
  static TextStyle get headlineXl => GoogleFonts.hankenGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: -0.02 * 32,
    color: AppColors.onSurface,
  );

  static TextStyle get headlineXlMobile => GoogleFonts.hankenGrotesk(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 32 / 26,
    letterSpacing: -0.02 * 26,
    color: AppColors.onSurface,
  );

  static TextStyle get headlineLg => GoogleFonts.hankenGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 30 / 24,
    letterSpacing: -0.015 * 24,
    color: AppColors.onSurface,
  );

  static TextStyle get headlineSm => GoogleFonts.hankenGrotesk(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    letterSpacing: -0.01 * 18,
    color: AppColors.onSurface,
  );

  static TextStyle get bodyLg => GoogleFonts.hankenGrotesk(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0,
    color: AppColors.onSurface,
  );

  static TextStyle get bodyMd => GoogleFonts.hankenGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0,
    color: AppColors.onSurface,
  );

  static TextStyle get bodySm => GoogleFonts.hankenGrotesk(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0.01 * 12,
    color: AppColors.onSurfaceVariant,
  );

  static TextStyle get labelLg => GoogleFonts.hankenGrotesk(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 18 / 14,
    letterSpacing: 0.02 * 14,
    color: AppColors.onSurface,
  );

  static TextStyle get labelMd => GoogleFonts.hankenGrotesk(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 14 / 11,
    letterSpacing: 0.06 * 11,
    color: AppColors.secondarySage,
  );

  static TextStyle get metricDisplay => GoogleFonts.hankenGrotesk(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 40 / 36,
    letterSpacing: -0.03 * 36,
    color: AppColors.onSurface,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}
