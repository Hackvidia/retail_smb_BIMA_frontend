import 'package:retail_smb/models/capture_flow_args.dart';
import 'package:retail_smb/models/starter_screen_args.dart';
import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/header_widget.dart';
import 'package:retail_smb/widgets/upload_document_widget.dart';
import 'package:retail_smb/widgets/upload_photo_widget.dart';
import 'package:flutter/material.dart';

class StarterScreen extends StatefulWidget {
  const StarterScreen({super.key});

  @override
  State<StarterScreen> createState() => _StarterScreenState();
}

class _StarterScreenState extends State<StarterScreen> {
  StarterEntryMode _mode = StarterEntryMode.returning;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    _isInitialized = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is StarterScreenArgs) {
      _mode = args.mode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFirstTime = _mode == StarterEntryMode.firstTime;

    return Scaffold(
      backgroundColor: AppColors.neutralWhiteBase,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSize.width(context, 0.07)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSize.width(context, 0.05),
            children: [
              HeaderWidget(
                title:
                    'Your operational business captured. Now let’s track your stocks!',
              ),
              UploadPhotoWidget(
                onUploadTap: () {
                  Navigator.pushNamed(
                    context,
                    '/camera-prep',
                    arguments: CameraPrepArgs(
                      markFirstInputOnUsePhoto: isFirstTime,
                      action: WarehouseStockAction.insert,
                    ),
                  );
                },
              ),
              if (!isFirstTime) UploadDocumentWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
