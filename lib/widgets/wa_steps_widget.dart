import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/theme/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:retail_smb/theme/app_sizing.dart';

class WaStepsWidget extends StatelessWidget {
  final List<String> steps;
  final double maxHeight;

  const WaStepsWidget(
      {super.key, required this.steps, required this.maxHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.width(context, 0.05)),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutralWhiteDarker),
        borderRadius: BorderRadius.circular(
          AppSize.width(context, 0.02),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Follow these steps to connect',
            style: AppTextStyles.bodyMediumBold,
          ),
          SizedBox(height: AppSize.width(context, 0.04)),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: maxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  steps.length,
                  (index) => _buildStep(
                    context,
                    index + 1,
                    steps[index],
                    isLast: index == steps.length - 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    int number,
    String text, {
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(
                AppSize.width(context, 0.015),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.neutralWhiteDarker,
                ),
                borderRadius: BorderRadius.circular(
                  AppSize.width(context, 0.015),
                ),
              ),
              child: Text(
                number.toString(),
                style: AppTextStyles.bodyMedium,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: AppSize.width(context, 0.08),
                color: Colors.grey.shade400,
              ),
          ],
        ),

        SizedBox(width: AppSize.width(context, 0.03)),

        /// Text
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }
}
