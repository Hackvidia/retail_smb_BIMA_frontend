import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/header_widget.dart';
import 'package:retail_smb/widgets/upload_photo_widget.dart';
import 'package:flutter/material.dart';

class UploadStock extends StatefulWidget {
  const UploadStock({super.key});

  @override
  State<UploadStock> createState() => _UploadStockState();
}

class _UploadStockState extends State<UploadStock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhiteLight,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSize.width(context, 0.08)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: AppSize.width(context, 0.04),
            children: [
              HeaderWidget(
                title:
                    'BIMA sudah memahami pola order kamu. Sekarang bantu BIMA tahu stok barangmu.',
              ),
              UploadPhotoWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
