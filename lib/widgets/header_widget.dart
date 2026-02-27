import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/custom_text_style.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  const HeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppSize.width(context, 0.01),
      children: [
        Image.asset('assets/images/sm-icon.png'),
        SizedBox(height: AppSize.width(context, 0.1)),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }
}
