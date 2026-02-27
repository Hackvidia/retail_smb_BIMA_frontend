import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/theme/custom_text_style.dart';
import 'package:flutter/material.dart';

class ConnectSuplierWidhet extends StatefulWidget {
  const ConnectSuplierWidhet({super.key});

  @override
  State<ConnectSuplierWidhet> createState() => _ConnectSuplierWidhetState();
}

class _ConnectSuplierWidhetState extends State<ConnectSuplierWidhet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryBimaBase,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: () {
          print('Connect selected suppliers');
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          foregroundColor: AppColors.neutralWhiteLighter,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Connect selected suppliers',
              style: AppTextStyles.button.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
