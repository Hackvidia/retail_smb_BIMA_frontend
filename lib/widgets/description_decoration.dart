import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/theme/custom_text_style.dart';
import 'package:flutter/material.dart';

class DescriptionDecoration extends StatelessWidget {
  final String content;
  const DescriptionDecoration({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSize.width(context, 0.01),
      right: AppSize.width(context, 0.1),
      child: Container(
        width: AppSize.width(context, 0.5),
        padding: EdgeInsets.all(AppSize.width(context, 0.03)),
        decoration: BoxDecoration(
          color: AppColors.neutralBlackDarker,
          border: Border.all(color: AppColors.neutralBlackBase),
          borderRadius: BorderRadius.circular(AppSize.width(context, 0.02)),
        ),
        child: Text(
          content,
          style: AppTextStyles.button,
        ),
      ),
    );
  }
}
