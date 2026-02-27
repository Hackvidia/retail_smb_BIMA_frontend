import 'package:flutter/material.dart';

class SignupTitleWidget extends StatelessWidget {
  const SignupTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Create Your Account',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 38,
            fontWeight: FontWeight.w700,
            height: 1.5,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Let's start creating your first BIMA account",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: Color(0xFF121926),
          ),
        ),
      ],
    );
  }
}
