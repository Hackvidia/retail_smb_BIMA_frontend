import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/theme/custom_text_style.dart';
import 'package:flutter/material.dart';

class ConnectWaWidget extends StatefulWidget {
  const ConnectWaWidget({super.key});

  @override
  State<ConnectWaWidget> createState() => _ConnectWaWidgetState();
}

class _ConnectWaWidgetState extends State<ConnectWaWidget> {
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
          Text(
            'Hubungkan WhatsApp Supplier',
            style: AppTextStyles.bodyMediumBold,
          ),
          Text(
            'Izinkan BIMA baca cara kamu biasa order',
            style: AppTextStyles.bodySmall,
          ),
          SizedBox(height: AppSize.width(context, 0.03)),
          Container(
            decoration: BoxDecoration(
              color: AppColors.systemGreenBase,
              border: Border.all(color: AppColors.neutralWhiteDarker),
              borderRadius: BorderRadius.circular(AppSize.width(context, 0.02)),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/wa-qr');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/wa-logo.png'),
                  SizedBox(width: AppSize.width(context, 0.01)),
                  Text('Connect Whatsapp', style: AppTextStyles.button),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
