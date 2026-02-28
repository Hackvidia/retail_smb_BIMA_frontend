import 'package:flutter/material.dart';
import 'package:retail_smb/theme/color_schema.dart';

class BeforeDashboardScreen extends StatelessWidget {
  const BeforeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 64),
                Image.asset(
                  'assets/images/bima-with-tablet.png',
                  width: 290,
                  height: 192,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 40),
                const Text(
                  "We're ready to start",
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
                  "BIMA already knows your store's order patterns and inventory today. "
                  "Let's see what BIMA can help you with next.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      '/home-screen',
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
                      'Enter the main page',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BeforeDashboardIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 290,
        height: 192,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Transform.rotate(
              angle: -0.42,
              child: Image.asset(
                'assets/images/sm-icon.png',
                width: 116,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 138,
              height: 116,
              decoration: BoxDecoration(
                color: const Color(0xFF7588ED),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF2A3C88),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Block(
                              width: 28, height: 22, color: Color(0xFFF7E27D)),
                          const SizedBox(width: 8),
                          _Block(
                              width: 20, height: 18, color: Color(0xFF98A8F8)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 28,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCE3FF),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/wa-logo.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                          _Block(
                              width: 24, height: 20, color: Color(0xFFF7E27D)),
                          _Block(
                              width: 14, height: 20, color: Color(0xFFDCE3FF)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
