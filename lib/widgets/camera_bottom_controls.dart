import 'dart:io';

import 'package:flutter/material.dart';
import 'package:retail_smb/theme/color_schema.dart';

class CameraBottomControls extends StatelessWidget {
  final String? thumbnailPath;
  final VoidCallback onOpenGallery;
  final VoidCallback onCapture;
  final VoidCallback onSwitchCamera;
  final bool captureEnabled;

  const CameraBottomControls({
    super.key,
    required this.thumbnailPath,
    required this.onOpenGallery,
    required this.onCapture,
    required this.onSwitchCamera,
    this.captureEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 204,
      width: double.infinity,
      color: const Color(0x99298191),
      padding: const EdgeInsets.fromLTRB(38, 38, 38, 52),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ThumbnailButton(path: thumbnailPath, onTap: onOpenGallery),
          _CaptureButton(onTap: captureEnabled ? onCapture : null),
          _RoundIconButton(
            onTap: onSwitchCamera,
            backgroundColor: const Color(0x59E3E8EF),
            icon: const Icon(
              Icons.cameraswitch,
              color: AppColors.primaryBimaDarker,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThumbnailButton extends StatelessWidget {
  final String? path;
  final VoidCallback onTap;

  const _ThumbnailButton({required this.path, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasPath = path != null && path!.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 65,
        height: 65,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.neutralWhiteLighter,
          borderRadius: BorderRadius.circular(6),
        ),
        child: hasPath
            ? Image.file(File(path!), fit: BoxFit.cover)
            : Image.asset('assets/images/bima-icon.png', fit: BoxFit.cover),
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _CaptureButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(48),
      child: Container(
        width: 86,
        height: 86,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.neutralWhiteLighter, width: 4),
        ),
        child: Center(
          child: Container(
            width: 66,
            height: 66,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.neutralWhiteBase,
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final Widget icon;

  const _RoundIconButton({
    required this.onTap,
    required this.backgroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28.5),
      child: Container(
        width: 57,
        height: 57,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Center(child: icon),
      ),
    );
  }
}
