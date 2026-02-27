import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/theme/custom_text_style.dart';
import 'package:flutter/material.dart';

class UploadPhotoWidget extends StatefulWidget {
  const UploadPhotoWidget({super.key});

  @override
  State<UploadPhotoWidget> createState() => _UploadPhotoWidgetState();
}

class _UploadPhotoWidgetState extends State<UploadPhotoWidget> {
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
          Text('Upload Foto Catatan Stok', style: AppTextStyles.bodyMediumBold),
          Text('BIMA bantu rapikan catatan', style: AppTextStyles.bodySmall),
          SizedBox(height: AppSize.width(context, 0.03)),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryBimaBase,
              border: Border.all(color: AppColors.neutralWhiteDarker),
              borderRadius: BorderRadius.circular(AppSize.width(context, 0.02)),
            ),
            child: TextButton(
              onPressed: () {
                print('hallo world');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.photo, color: AppColors.neutralWhiteDark),
                  SizedBox(width: AppSize.width(context, 0.01)),
                  Text('Upload Foto', style: AppTextStyles.button),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
