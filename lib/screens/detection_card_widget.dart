import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/theme/custom_text_style.dart';
import 'package:flutter/material.dart';

class DetectionCardWidget extends StatefulWidget {
  const DetectionCardWidget({super.key});

  @override
  State<DetectionCardWidget> createState() => _DetectionCardWidgetState();
}

class _DetectionCardWidgetState extends State<DetectionCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.width(context, 0.04)),
      decoration: BoxDecoration(
        color: AppColors.neutralWhiteLight,
        border: Border.all(color: AppColors.primaryBimaBase),
        borderRadius: BorderRadius.circular(AppSize.width(context, 0.02)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSize.width(context, 0.03),
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ANL AC TIFIT 3X MP GINGER 20G (12X10 SACHET)',
                  style: AppTextStyles.bodySmallBold,
                ),
                SizedBox(height: AppSize.width(context, 0.01)),
                Text('3 RENCENG', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryBimaLight,
              borderRadius: BorderRadius.circular(
                AppSize.width(context, 0.001),
              ),
              border: Border.all(color: AppColors.primaryBimaBase),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    print("Container tapped!");
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSize.width(context, 0.01),
                      horizontal: AppSize.width(context, 0.03),
                    ),
                    child: Icon(Icons.remove, size: 15),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSize.width(context, 0.01),
                    horizontal: AppSize.width(context, 0.03),
                  ),
                  color: AppColors.neutralWhiteLight,
                  child: Text('3', style: AppTextStyles.bodySmall),
                ),
                GestureDetector(
                  onTap: () {
                    print("Container tapped!");
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSize.width(context, 0.01),
                      horizontal: AppSize.width(context, 0.03),
                    ),
                    child: Icon(Icons.add, size: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
