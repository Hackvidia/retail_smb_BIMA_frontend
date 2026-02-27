import 'package:flutter/material.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/login_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhiteLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                const _LoginHero(),
                const SizedBox(height: 8),
                const LoginWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginHero extends StatelessWidget {
  const _LoginHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/images/puzzle-piece-icon.png',
                width: 120,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/images/bima-icon.png',
                width: 170,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PuzzleShape extends StatelessWidget {
  const _PuzzleShape({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final double nub = size * 0.24;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * 0.78,
            height: size * 0.78,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFB9B9BD)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A7F9BF6),
                  offset: Offset(0, 2),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0, -1),
            child: _Nub(size: nub),
          ),
          Align(
            alignment: const Alignment(1, 0),
            child: _Nub(size: nub),
          ),
          Align(
            alignment: const Alignment(-1, 0.26),
            child: _Nub(size: nub),
          ),
        ],
      ),
    );
  }
}

class _Nub extends StatelessWidget {
  const _Nub({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFB9B9BD)),
      ),
    );
  }
}
