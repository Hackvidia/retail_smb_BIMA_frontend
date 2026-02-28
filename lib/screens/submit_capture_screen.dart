import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:retail_smb/models/capture_flow_args.dart';
import 'package:retail_smb/models/detection_result_item.dart';
import 'package:retail_smb/services/document_extract_service.dart';
import 'package:retail_smb/state/app_session_state.dart';
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
  bool _markFirstInputOnUsePhoto = false;
  String? _stockDocumentType;
  bool _isSubmitting = false;
  final DocumentExtractService _extractService = DocumentExtractService();

  void _retakePhoto() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.pushReplacementNamed(context, '/scan-camera');
  }

  Future<void> _usePhoto() async {
    if (_isSubmitting) return;
    final imagePath = _imagePath;
    if (imagePath == null || imagePath.isEmpty) {
      _showSnack('No image selected.');
      return;
    }
    final stockDocumentType = _stockDocumentType;
    if (stockDocumentType == null || stockDocumentType.trim().isEmpty) {
      _showSnack('Document type is missing. Please retake from Camera Prep.');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await AppSessionState.instance.hydrate();
      final token = AppSessionState.instance.authToken;
      if (token == null || token.trim().isEmpty) {
        _showSnack('Session expired. Please login again.');
        return;
      }

      final result = await _extractService.uploadCameraPhoto(
        cameraDocumentType: stockDocumentType,
        imagePath: imagePath,
        token: token,
      );
      if (!result.success) {
        _showSnack(result.message ?? 'Failed to upload photo.');
        return;
      }

      if (_markFirstInputOnUsePhoto) {
        AppSessionState.instance.markFirstInputCompleted();
      }

      final detectedItems = result.items
          .map(
            (item) => DetectionResultItem(
              id: item.id,
              name: item.name,
              unitPrice: item.unitPrice,
              quantity: item.quantity,
              unitLabel: item.unitLabel,
              sourceNames: item.sourceNames,
            ),
          )
          .toList();

      debugPrint(
        '[SubmitCaptureScreen] Upload success type=$stockDocumentType extractionId=${result.extractionId} items=${detectedItems.length}',
      );

      final extractionId = result.extractionId?.trim();
      if (extractionId == null || extractionId.isEmpty) {
        _showSnack('Extraction succeeded but extractionId is missing.');
        return;
      }
      final confirmEndpoint = _extractService.cameraConfirmEndpoint(stockDocumentType);
      final manualAddEndpoint = _extractService.cameraManualAddEndpoint(
        stockDocumentType,
        extractionId,
      );

      final args = PhotoDetectionArgs(
        imagePath: imagePath,
        detectedItems: detectedItems,
        extractionId: extractionId,
        confirmEndpoint: confirmEndpoint,
        manualAddEndpoint: manualAddEndpoint,
        sourceType: stockDocumentType,
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        '/photo-detection-result',
        arguments: args,
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final routeArgument = ModalRoute.of(context)?.settings.arguments;
    if (_imagePath == null) {
      if (widget.imagePath != null && widget.imagePath!.isNotEmpty) {
        _imagePath = widget.imagePath;
      } else if (routeArgument is SubmitCaptureArgs) {
        _imagePath = routeArgument.imagePath;
        _markFirstInputOnUsePhoto = routeArgument.markFirstInputOnUsePhoto;
        _stockDocumentType = routeArgument.stockDocumentType;
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
                                      onPressed: _isSubmitting ? null : _usePhoto,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              _isSubmitting
                                                  ? 'Uploading...'
                                                  : 'Use Photo',
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
