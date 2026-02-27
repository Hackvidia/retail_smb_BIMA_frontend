import 'package:retail_smb/screens/detection_card_widget.dart';
import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/theme/custom_text_style.dart';
import 'package:retail_smb/widgets/description_decoration.dart';
import 'package:retail_smb/widgets/hero_widget.dart';
import 'package:flutter/material.dart';

class PhotoDetectionResult extends StatefulWidget {
  const PhotoDetectionResult({super.key});

  @override
  State<PhotoDetectionResult> createState() => _PhotoDetectionResultState();
}

class _PhotoDetectionResultState extends State<PhotoDetectionResult> {
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
                  content: 'Hasil pembacaan catatan stok kamu!',
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
                              Text(
                                'PT. MITRA SEHATI SEKATA',
                                style: AppTextStyles.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: AppSize.height(context, 0.5),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    spacing: AppSize.width(context, 0.03),
                                    children: [
                                      DetectionCardWidget(),
                                      DetectionCardWidget(),
                                      DetectionCardWidget(),
                                      DetectionCardWidget(),
                                      DetectionCardWidget(),
                                      DetectionCardWidget(),
                                    ],
                                  ),
                                ),
                              ),
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
                                              'Tambah catatan',
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
                                              'Simpan',
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
