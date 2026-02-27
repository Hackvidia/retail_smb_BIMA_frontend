import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/theme/custom_text_style.dart';
import 'package:flutter/material.dart';

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Toko Sembako Sumber Jaya',
          style: TextStyle(
            fontSize: AppSize.width(context, 0.05),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: AppSize.width(context, 0.05),
        ),
        Container(
          width: AppSize.screenWidth(context),
          padding: EdgeInsets.all(AppSize.width(context, 0.04)),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: AppColors.neutralWhiteDarker, width: 1),
            borderRadius: BorderRadius.circular(AppSize.width(context, 0.02)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You order the most often Indomie goreng',
                style: AppTextStyles.bodyMedium,
              ),
              SizedBox(height: AppSize.width(context, 0.01)),
              Text('Around once a week', style: AppTextStyles.bodySmall),
            ],
          ),
        ),
        SizedBox(
          height: AppSize.width(context, 0.02),
        ),
        Container(
          width: AppSize.screenWidth(context),
          padding: EdgeInsets.all(AppSize.width(context, 0.04)),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: AppColors.neutralWhiteDarker, width: 1),
            borderRadius: BorderRadius.circular(AppSize.width(context, 0.02)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Products that are regularly ordered:',
                style: AppTextStyles.bodyMedium,
              ),
              SizedBox(height: AppSize.width(context, 0.02)),
              Text('- Aqua 600ml', style: AppTextStyles.bodySmall),
              Text('- Kopi Kapal Api', style: AppTextStyles.bodySmall),
              Text('- Teh Botol Sosro', style: AppTextStyles.bodySmall),
            ],
          ),
        ),
        SizedBox(
          height: AppSize.width(context, 0.02),
        ),
        Container(
          width: AppSize.screenWidth(context),
          padding: EdgeInsets.all(AppSize.width(context, 0.04)),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: AppColors.neutralWhiteDarker, width: 1),
            borderRadius: BorderRadius.circular(AppSize.width(context, 0.02)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Average you order', style: AppTextStyles.bodyMedium),
              SizedBox(height: AppSize.width(context, 0.01)),
              Text(
                '2-3 types goods at once',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
