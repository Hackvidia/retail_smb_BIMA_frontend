import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/theme/custom_text_style.dart';
import 'package:retail_smb/widgets/description_decoration.dart';
import 'package:retail_smb/widgets/hero_widget.dart';
import 'package:retail_smb/widgets/summary_widget.dart';
import 'package:flutter/material.dart';

class SumarySuplierChatScreen extends StatefulWidget {
  const SumarySuplierChatScreen({super.key});

  @override
  State<SumarySuplierChatScreen> createState() =>
      _SumarySuplierChatScreenState();
}

class _SumarySuplierChatScreenState extends State<SumarySuplierChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhiteLight,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSize.width(context, 0.05)),
            child: Stack(
              children: [
                HeroWidget(),
                DescriptionDecoration(
                  content: 'Summary of your supplier chat',
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppSize.width(context, 0.05)),
                      decoration: BoxDecoration(
                        color: AppColors.neutralWhiteLighter,
                        border: Border.all(color: AppColors.primaryBimaBase),
                        borderRadius: BorderRadius.circular(
                          AppSize.width(context, 0.02),
                        ),
                      ),
                      child: Column(
                        spacing: AppSize.width(context, 0.08),
                        children: [
                          SummaryWidget(),
                          Text(
                            'This is just an initial summary dari BIMA for you. BIMA will become more accurate as more data is added',
                            style: TextStyle(
                              fontSize: AppSize.width(context, 0.04),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryBimaBase,
                              border: Border.all(
                                color: AppColors.neutralWhiteDarker,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppSize.width(context, 0.02),
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {
                                print('hallo world');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Lanjutkan',
                                    style: AppTextStyles.button,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
