import 'package:flutter/material.dart';

class SignupFormFieldsWidget extends StatelessWidget {
  const SignupFormFieldsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _SignupField(
          label: 'WhatsApp Number',
          hintText: '+62-000-000-000',
          fontFamily: 'Inter',
          prefixIcon: Icons.phone_outlined,
          suffixIcon: Icons.help_outline,
        ),
        SizedBox(height: 14),
        _SignupField(
          label: 'Password',
          hintText: '***********',
          fontFamily: 'Lato',
        ),
        SizedBox(height: 14),
        _SignupField(
          label: 'Repeat Password',
          hintText: '***********',
          fontFamily: 'Inter',
        ),
      ],
    );
  }
}

class _SignupField extends StatelessWidget {
  const _SignupField({
    required this.label,
    required this.hintText,
    required this.fontFamily,
    this.prefixIcon,
    this.suffixIcon,
  });

  final String label;
  final String hintText;
  final String fontFamily;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: fontFamily == 'Lato' ? 'Lato' : 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
            color: const Color(0xFF011829),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFD4D4D8)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D101828),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: TextFormField(
            obscureText: label.toLowerCase().contains('password'),
            obscuringCharacter: '*',
            initialValue: hintText,
            style: TextStyle(
              fontFamily: fontFamily == 'Lato' ? 'Lato' : 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 24 / 16,
              color: const Color(0xFF121926),
            ),
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(prefixIcon, size: 20, color: const Color(0xFF121926)),
              suffixIcon: suffixIcon == null
                  ? null
                  : Icon(suffixIcon, size: 16, color: const Color(0xFFA1A1AA)),
            ),
          ),
        ),
      ],
    );
  }
}
