import 'package:flutter/material.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';

class AppTextTheme {
  static const String _fontFamily = "Inter";

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: AppColors.black,
    ),
    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: AppColors.gray,
    ),
    labelMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.gray,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    // ADD if needed
  );
}