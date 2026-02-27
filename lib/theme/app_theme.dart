import 'package:flutter/material.dart';
import 'package:retail_smb/theme/color_schema.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.neutralWhiteBase,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.neutralBlackBase,
      ),
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.neutralBlackBase,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.neutralBlackLight),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.neutralBlackLight),
    ),
  );
}
