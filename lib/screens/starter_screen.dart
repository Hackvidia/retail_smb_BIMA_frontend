import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/connect_wa_widget.dart';
import 'package:retail_smb/widgets/header_widget.dart';
import 'package:retail_smb/widgets/upload_photo_widget.dart';
import 'package:flutter/material.dart';

class StarterScreen extends StatefulWidget {
  const StarterScreen({super.key});

  @override
  State<StarterScreen> createState() => _StarterScreenState();
}

class _StarterScreenState extends State<StarterScreen> {
  @override
  Widget build(BuildContext context) {
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
                title: 'Kita mulai dari yang paling mudah untukmu ya!',
              ),
              ConnectWaWidget(),
              UploadPhotoWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
