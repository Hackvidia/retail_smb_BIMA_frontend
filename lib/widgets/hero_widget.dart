import 'package:retail_smb/theme/app_sizing.dart';
import 'package:flutter/material.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppSize.width(context, 0.05),
      top: AppSize.width(context, 0.05),
      child: Image.asset('assets/images/bima-left-icon.png'),
    );
  }
}
