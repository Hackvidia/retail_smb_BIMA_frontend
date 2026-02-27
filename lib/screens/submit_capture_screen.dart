import 'dart:io';

import 'package:retail_smb/models/detection_result_item.dart';
import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/theme/custom_text_style.dart';
import 'package:retail_smb/widgets/description_decoration.dart';
import 'package:retail_smb/widgets/hero_widget.dart';
import 'package:flutter/material.dart';

class SubmitCaptureScreen extends StatefulWidget {
  final String? imagePath;
  const SubmitCaptureScreen({super.key, this.imagePath});

  @override
  State<SubmitCaptureScreen> createState() => _SubmitCaptureScreenState();
}

class _SubmitCaptureScreenState extends State<SubmitCaptureScreen> {
  String? _imagePath;

  void _retakePhoto() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.pushReplacementNamed(context, '/scan-camera');
  }

  void _usePhoto() {
    final args = PhotoDetectionArgs(
      imagePath: _imagePath,
      detectedItems: const [
        DetectionResultItem(
          id: 'item-1',
          name: 'ANL ACTIFIT 3X MP GINGER 20G (12X10 SACHET)',
          unitPrice: 20833,
          quantity: 3,
        ),
        DetectionResultItem(
          id: 'item-2',
          name: 'SUSU KENTAL MANIS COKLAT 370 GR',
          unitPrice: 12500,
          quantity: 2,
        ),
      ],
    );

    Navigator.pushReplacementNamed(
      context,
      '/photo-detection-result',
      arguments: args,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgument = ModalRoute.of(context)?.settings.arguments;
    if (_imagePath == null) {
      if (widget.imagePath != null && widget.imagePath!.isNotEmpty) {
        _imagePath = widget.imagePath;
      } else if (routeArgument is String && routeArgument.isNotEmpty) {
        _imagePath = routeArgument;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = _imagePath != null
        ? Image.file(
            File(_imagePath!),
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) {
              return Image.asset('assets/images/bima-icon.png',
                  fit: BoxFit.contain);
            },
          )
        : Image.asset('assets/images/bima-icon.png', fit: BoxFit.contain);

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
                  content: 'Double check your photo before submit',
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
                              Expanded(child: Center(child: imageWidget)),
                              SizedBox(height: AppSize.height(context, 0.02)),
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
                                      onPressed: _retakePhoto,
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
                                      onPressed: _usePhoto,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              'Use Photo',
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
