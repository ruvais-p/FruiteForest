import 'package:flutter/material.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';
import 'package:fruiteforest/common/theme/text_theme/text_theme.dart';

class AppTheme {
  static ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    textTheme: AppTextTheme.lightTextTheme,
  );
}
