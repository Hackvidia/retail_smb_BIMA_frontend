import 'package:flutter/material.dart';
import 'package:retail_smb/theme/color_schema.dart';

class AppTextStyles {
  static const titleMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 21,
    fontWeight: FontWeight.bold,
    color: AppColors.neutralBlackLight,
  );

  static const bodyMediumBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.neutralBlackLight,
  );

  static const bodySmallBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: AppColors.neutralBlackLight,
  );

  static const bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.neutralBlackLight,
  );

  static const bodySmall = TextStyle(
    fontFamily: 'Lato',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.neutralBlackLight,
  );

  static const button = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.neutralWhiteLighter,
  );

  static const buttonSecondary = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryBimaBase,
  );
}
