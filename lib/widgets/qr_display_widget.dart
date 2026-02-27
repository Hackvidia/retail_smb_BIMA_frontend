import 'package:retail_smb/theme/app_sizing.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrDisplayWidget extends StatefulWidget {
  final String qrData;
  const QrDisplayWidget({super.key, required this.qrData});

  @override
  State<QrDisplayWidget> createState() => _QrDisplayWidgetState();
}

class _QrDisplayWidgetState extends State<QrDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: QrImageView(
        data: widget.qrData,
        version: QrVersions.auto,
        size: AppSize.width(context, 0.55),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
