import 'package:flutter/material.dart';
import 'package:retail_smb/models/capture_flow_args.dart';
import 'package:retail_smb/state/app_session_state.dart';
import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/theme/custom_text_style.dart';

class UploadDocumentWidget extends StatelessWidget {
  const UploadDocumentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.screenWidth(context),
      padding: EdgeInsets.all(AppSize.width(context, 0.05)),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutralWhiteDarker),
        borderRadius: BorderRadius.circular(AppSize.width(context, 0.02)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Upload Sales & Cost', style: AppTextStyles.bodyMediumBold),
          Text(
            'Use this to subtract stocks from warehouse',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSize.width(context, 0.03)),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryBimaBase,
              border: Border.all(color: AppColors.neutralWhiteDarker),
              borderRadius: BorderRadius.circular(AppSize.width(context, 0.02)),
            ),
            child: TextButton(
              onPressed: () {
                AppSessionState.instance
                    .setCurrentStockAction(WarehouseStockAction.subtract);
                Navigator.pushNamed(context, '/operational-documents');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.description, color: AppColors.neutralWhiteDark),
                  SizedBox(width: AppSize.width(context, 0.01)),
                  Text('Upload Sales & Cost', style: AppTextStyles.button),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
