import 'package:flutter/material.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';

class AppTextTheme {
  static const String _fontFamily = "Inter";

  static TextTheme lightTextTheme = TextTheme(
    // Page titles (48px)
    headlineLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: AppColors.black,
    ),
    // Section titles (22px)
    titleLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.black,
    ),
    // Card/Item titles (18px)
    titleMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.black,
    ),
    // Subtitle (16px)
    titleSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.black,
    ),
    // Body text large (16px)
    bodyLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.black,
    ),
    // Body text medium (14px)
    bodyMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.black,
    ),
    // Body text small (12px)
    bodySmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.gray,
    ),
    // Large labels (20px gray)
    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: AppColors.gray,
    ),
    // Medium labels (14px gray)
    labelMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.gray,
    ),
    // Small labels (12px gray)
    labelSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.gray,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    // ADD if needed
  );
}
