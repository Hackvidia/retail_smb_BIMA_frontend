import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/header_widget.dart';
import 'package:retail_smb/widgets/qr_display_widget.dart';
import 'package:retail_smb/widgets/wa_steps_widget.dart';
import 'package:flutter/material.dart';

class WaQrScreen extends StatefulWidget {
  const WaQrScreen({super.key});

  @override
  State<WaQrScreen> createState() => _WaQrScreenState();
}

class _WaQrScreenState extends State<WaQrScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhiteBase,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSize.width(context, 0.07)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: AppSize.width(context, 0.07),
            children: [
              HeaderWidget(
                title: 'Scan QR untuk menghubungkan ke WhatsAppmu ya..',
              ),
              QrDisplayWidget(qrData: "Ini adalah kode QR saya"),
              WaStepsWidget(
                maxHeight: AppSize.width(context, 0.7),
                steps: [
                  'Open the WhatsApp application on your phone',
                  'On Android tap Menu, and on iPhone tap Settings',
                  'Click on the connected device, then connect the device',
                  'Scan QR code to confirm',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
