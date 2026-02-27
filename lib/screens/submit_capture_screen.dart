import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/theme/custom_text_style.dart';
import 'package:retail_smb/widgets/description_decoration.dart';
import 'package:retail_smb/widgets/hero_widget.dart';
import 'package:flutter/material.dart';

class SubmitCaptureScreen extends StatefulWidget {
  const SubmitCaptureScreen({super.key});

  @override
  State<SubmitCaptureScreen> createState() => _SubmitCaptureScreenState();
}

class _SubmitCaptureScreenState extends State<SubmitCaptureScreen> {
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
                  content: 'Cek kembali foto yang kamu ambil',
                ),
                SizedBox(
                  height: AppSize.screenHeight(context),
                  width: AppSize.screenWidth(context),
                  child: Column(
                    children: [
                      SizedBox(
                        height: AppSize.height(context, 0.12),
                        width: AppSize.screenWidth(context),
                      ),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(AppSize.width(context, 0.05)),
                          width: AppSize.screenWidth(context),
                          height: AppSize.height(context, 0.70),
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            color: AppColors.neutralWhiteLighter,
                            border: Border.all(
                              color: AppColors.primaryBimaBase,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppSize.width(context, 0.02),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset('assets/images/sample.png'),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // tambah catatan button
                                  Container(
                                    width: AppSize.width(context, 0.39),
                                    decoration: BoxDecoration(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Ambil Ulang',
                                              style:
                                                  AppTextStyles.buttonSecondary,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // simpan button
                                  Container(
                                    width: AppSize.width(context, 0.3),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              'Gunakan',
                                              style: AppTextStyles.button,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
          ),
        ),
      ),
    );
  }
}
