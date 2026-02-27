import 'package:flutter/material.dart';
import 'package:retail_smb/theme/color_schema.dart';

class CameraOverlayFrame extends StatelessWidget {
  final double frameWidth;
  final double frameHeight;
  final Color overlayColor;
  final Color frameColor;

  const CameraOverlayFrame({
    super.key,
    required this.frameWidth,
    required this.frameHeight,
    this.overlayColor = const Color(0x73000000),
    this.frameColor = AppColors.primaryBimaBase,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _CameraOverlayPainter(
          frameWidth: frameWidth,
          frameHeight: frameHeight,
          overlayColor: overlayColor,
          frameColor: frameColor,
        ),
      ),
    );
  }
}

class _CameraOverlayPainter extends CustomPainter {
  final double frameWidth;
  final double frameHeight;
  final Color overlayColor;
  final Color frameColor;

  const _CameraOverlayPainter({
    required this.frameWidth,
    required this.frameHeight,
    required this.overlayColor,
    required this.frameColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final frameRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: frameWidth,
      height: frameHeight,
    );

    final overlayPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addRect(frameRect);

    canvas.drawPath(overlayPath, Paint()..color = overlayColor);

    const cornerLength = 56.0;
    const sideLength = 108.0;
    const strokeWidth = 4.0;

    final paint = Paint()
      ..color = frameColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final left = frameRect.left;
    final right = frameRect.right;
    final top = frameRect.top;
    final bottom = frameRect.bottom;

    canvas.drawLine(Offset(left, top), Offset(left + cornerLength, top), paint);
    canvas.drawLine(Offset(left, top), Offset(left, top + sideLength), paint);

    canvas.drawLine(Offset(right - cornerLength, top), Offset(right, top), paint);
    canvas.drawLine(Offset(right, top), Offset(right, top + sideLength), paint);

    canvas.drawLine(
      Offset(left, bottom - sideLength),
      Offset(left, bottom),
      paint,
    );
    canvas.drawLine(
      Offset(left, bottom),
      Offset(left + cornerLength, bottom),
      paint,
    );

    canvas.drawLine(
      Offset(right, bottom - sideLength),
      Offset(right, bottom),
      paint,
    );
    canvas.drawLine(
      Offset(right - cornerLength, bottom),
      Offset(right, bottom),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CameraOverlayPainter oldDelegate) {
    return oldDelegate.frameWidth != frameWidth ||
        oldDelegate.frameHeight != frameHeight ||
        oldDelegate.overlayColor != overlayColor ||
        oldDelegate.frameColor != frameColor;
  }
}
