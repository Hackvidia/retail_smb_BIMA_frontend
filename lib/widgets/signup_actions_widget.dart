import 'package:flutter/material.dart';
import 'package:retail_smb/theme/color_schema.dart';

class SignupActionsWidget extends StatelessWidget {
  const SignupActionsWidget({
    super.key,
    required this.onGetStarted,
    required this.onAlreadyAccount,
  });

  final VoidCallback onGetStarted;
  final VoidCallback onAlreadyAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onGetStarted,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBimaBase,
              foregroundColor: AppColors.neutralWhiteLighter,
              elevation: 0,
              shadowColor: const Color(0x0D101828),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: AppColors.primaryBimaBase),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'GET STARTED',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: onAlreadyAccount,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.neutralBlackDarker,
            padding: const EdgeInsets.symmetric(vertical: 4),
          ),
          child: const Text(
            'I ALREADY HAVE AN ACCOUNT',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
