import 'package:flutter/material.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/signup_actions_widget.dart';
import 'package:retail_smb/widgets/signup_hero_widget.dart';
import 'package:retail_smb/widgets/signup_title_widget.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxHeight = constraints.maxHeight;
            final double topSpace = (maxHeight * 0.22).clamp(56.0, 170.0);
            final double heroToTitle = (maxHeight * 0.065).clamp(26.0, 56.0);
            final double titleToActions = (maxHeight * 0.09).clamp(36.0, 82.0);

            return Container(
              color: const Color(0xFFFEFEFF),
              width: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: maxHeight),
                    child: SizedBox(
                      width: 360,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: topSpace),
                          const SignupHeroWidget(),
                          SizedBox(height: heroToTitle),
                          const SignupTitleWidget(),
                          SizedBox(height: titleToActions),
                          SignupActionsWidget(
                            onGetStarted: () => Navigator.pushReplacementNamed(
                              context,
                              '/before-dashboard',
                            ),
                            onAlreadyAccount: () =>
                                Navigator.pushReplacementNamed(
                              context,
                              '/login',
                            ),
                          ),
                          const SizedBox(height: 22),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
