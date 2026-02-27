import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/theme/custom_text_style.dart';
import 'package:flutter/material.dart';

class ConnectSuplierWidhet extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool enabled;

  const ConnectSuplierWidhet({
    super.key,
    this.onPressed,
    this.label = 'Connect selected suppliers',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        enabled ? AppColors.primaryBimaBase : AppColors.neutralGreyDark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextButton(
        onPressed: enabled ? onPressed : null,
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
              label,
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
