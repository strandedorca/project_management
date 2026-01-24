import 'package:flutter/material.dart';
import 'package:project_manager/themes/text_styles.dart';

import 'color_scheme.dart';
import 'colors.dart';

// Define a custom class called AppTheme
class AppTheme {
  // A static method (getter) that returns a ThemeData object for light theme
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: AppColorScheme.light,
      textTheme: AppTextStyles.lightTextTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      useMaterial3: false,
    );
  }
}
