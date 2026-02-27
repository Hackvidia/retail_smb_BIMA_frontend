import 'package:flutter/material.dart';
import 'package:retail_smb/screens/login_screen.dart';
import 'package:retail_smb/theme/color_schema.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhiteLighter,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 36),
                const _SplashHero(),
                const SizedBox(height: 40),
                const Text(
                  'BIMA',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: AppColors.neutralBlackDarker,
                  ),
                ),
                const SizedBox(height: 11),
                const Text(
                  'Slowly, we make ordering\ndecisions more relaxed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    color: AppColors.neutralBlackDarker,
                  ),
                ),
                const SizedBox(height: 11),
                const Text(
                  'Start from the habits you already have',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 72),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBimaBase,
                      foregroundColor: AppColors.neutralWhiteLighter,
                      elevation: 0,
                      shadowColor: const Color(0x0D101828),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side:
                            const BorderSide(color: AppColors.primaryBimaBase),
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
                  onPressed: () =>
                      Navigator.of(context).pushReplacementNamed('/login'),
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
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashHero extends StatelessWidget {
  const _SplashHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 210,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: const Alignment(-0.78, 0.24),
            child: Transform.rotate(
              angle: -0.48,
              child: _PuzzleShape(size: 112),
            ),
          ),
          Align(
            alignment: const Alignment(0.88, -0.46),
            child: Transform.rotate(
              angle: -2.48,
              child: _PuzzleShape(size: 56),
            ),
          ),
          Image.asset(
            'assets/images/sm-icon.png',
            width: 180,
            fit: BoxFit.contain,
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
              color: AppColors.neutralWhiteLighter,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF95A9F5)),
            ),
          ),
          Align(
            alignment: const Alignment(0, -1),
            child: Container(
              width: nub,
              height: nub,
              decoration: BoxDecoration(
                color: AppColors.neutralWhiteLighter,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF95A9F5)),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(1, 0),
            child: Container(
              width: nub,
              height: nub,
              decoration: BoxDecoration(
                color: AppColors.neutralWhiteLighter,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF95A9F5)),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-1, 0.26),
            child: Container(
              width: nub,
              height: nub,
              decoration: BoxDecoration(
                color: AppColors.neutralWhiteLighter,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF95A9F5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
