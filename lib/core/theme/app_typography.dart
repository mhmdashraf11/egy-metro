import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTypography {
  static TextStyle get _baseInter => GoogleFonts.inter();
  static TextStyle get _baseArabic => GoogleFonts.notoSansArabic();

  // ─── Cairo Transit Premium Scale (Dark) ──────────────────────────────────
  static TextStyle darkDisplayLarge = _baseInter.copyWith(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 56 / 48,
    letterSpacing: -0.02,
  );

  static TextStyle darkHeadlineMedium = _baseInter.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: -0.01,
  );

  static TextStyle darkTitleLarge = _baseInter.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
  );

  static TextStyle darkBodyMedium = _baseInter.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static TextStyle darkLabelSmall = _baseInter.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
  );

  // ─── Legacy Scale (Light) ────────────────────────────────────────────────
  static TextStyle displayLarge = _baseInter.copyWith(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    height: 64 / 57,
    letterSpacing: -0.25,
  );

  static TextStyle headlineMedium = _baseInter.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 36 / 28,
  );

  static TextStyle titleLarge = _baseInter.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 28 / 22,
  );

  static TextStyle bodyLarge = _baseInter.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  static TextStyle labelMedium = _baseInter.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.5,
  );

  // ─── Arabic Overrides (Higher Line Height) ────────────────────────────────
  static TextStyle darkDisplayLargeAr = _baseArabic.copyWith(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.4,
  );

  static TextStyle darkHeadlineMediumAr = _baseArabic.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextTheme get lightTextTheme => TextTheme(
    displayLarge: displayLarge,
    headlineMedium: headlineMedium,
    titleLarge: titleLarge,
    bodyLarge: bodyLarge,
    labelMedium: labelMedium,
  );

  static TextTheme get darkTextTheme => TextTheme(
    displayLarge: darkDisplayLarge,
    headlineMedium: darkHeadlineMedium,
    titleLarge: darkTitleLarge,
    bodyMedium: darkBodyMedium,
    labelSmall: darkLabelSmall,
  );

  // Default for backward compatibility
  static TextTheme get textTheme => lightTextTheme;
}
