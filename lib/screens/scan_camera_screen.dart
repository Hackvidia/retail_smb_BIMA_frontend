import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/camera_bottom_controls.dart';
import 'package:retail_smb/widgets/camera_overlay_frame.dart';

class ScanCameraScreen extends StatefulWidget {
  const ScanCameraScreen({super.key});

  @override
  State<ScanCameraScreen> createState() => _ScanCameraScreenState();
}

class _ScanCameraScreenState extends State<ScanCameraScreen>
    with WidgetsBindingObserver {
  final ImagePicker _picker = ImagePicker();

  List<CameraDescription> _cameras = const [];
  CameraController? _controller;
  int _selectedCameraIndex = 0;
  String? _lastImagePath;

  bool _isInitializing = true;
  bool _isCapturing = false;
  bool _isPermissionPermanentlyDenied = false;
  String? _errorMessage;
  int _initRequestId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_initializeCamera());
  }

  @override
  void dispose() {
    _initRequestId++;
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      final controller = _controller;
      if (controller == null) return;
      unawaited(controller.dispose());
      _controller = null;
      return;
    }

    if (state == AppLifecycleState.resumed) {
      if (!(ModalRoute.of(context)?.isCurrent ?? true)) return;
      unawaited(_initializeCamera(startIndex: _selectedCameraIndex));
    }
  }

  Future<void> _initializeCamera({int? startIndex}) async {
    final requestId = ++_initRequestId;
    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });

    CameraController? nextController;
    try {
      final hasPermission = await _ensureCameraPermission();
      if (!hasPermission) {
        if (requestId != _initRequestId) return;
        if (!mounted) return;
        setState(() {
          _isInitializing = false;
          _errorMessage = _isPermissionPermanentlyDenied
              ? 'Camera permission is permanently denied. Please enable it from app settings.'
              : 'Camera permission is required to take photo.';
        });
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraException('no_camera', 'No available camera on this device.');
      }

      final index = (startIndex ?? _selectedCameraIndex).clamp(0, cameras.length - 1);
      nextController = await _createControllerWithFallback(cameras[index]);
      if (!mounted || requestId != _initRequestId) {
        await nextController.dispose();
        return;
      }

      final oldController = _controller;
      setState(() {
        _cameras = cameras;
        _selectedCameraIndex = index;
        _controller = nextController;
        _isInitializing = false;
      });
      await oldController?.dispose();
      nextController = null;
    } on CameraException catch (error) {
      await nextController?.dispose();
      if (requestId != _initRequestId) return;
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
        if (error.code == 'CameraAccessDenied' ||
            error.code == 'CameraAccessDeniedWithoutPrompt' ||
            error.code == 'CameraAccessRestricted') {
          _errorMessage = 'Camera permission is required to take photo.';
        } else {
          _errorMessage = error.description ?? error.code;
        }
      });
    } catch (error) {
      await nextController?.dispose();
      if (requestId != _initRequestId) return;
      if (!mounted) return;
      final errorText = error.toString();
      setState(() {
        _isInitializing = false;
        if (errorText.contains('IllegalArgumentException')) {
          _errorMessage =
              'Camera configuration is not supported on this device. Please retry.';
        } else {
          _errorMessage = 'Camera initialization failed. Please try again.';
        }
      });
    }
  }

  Future<CameraController> _createControllerWithFallback(
    CameraDescription camera,
  ) async {
    final presets = <ResolutionPreset>[
      ResolutionPreset.high,
      ResolutionPreset.medium,
      ResolutionPreset.low,
    ];

    Object? lastError;
    for (final preset in presets) {
      final controller = CameraController(
        camera,
        preset,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      try {
        await controller.initialize();
        return controller;
      } catch (error) {
        lastError = error;
        await controller.dispose();
      }
    }

    if (lastError is CameraException) {
      throw lastError;
    }
    throw CameraException(
      'init_failed',
      lastError?.toString() ?? 'Unknown camera initialization error.',
    );
  }

  Future<bool> _ensureCameraPermission() async {
    final currentStatus = await Permission.camera.status;

    if (currentStatus.isGranted) {
      _isPermissionPermanentlyDenied = false;
      return true;
    }

    if (currentStatus.isPermanentlyDenied || currentStatus.isRestricted) {
      _isPermissionPermanentlyDenied = true;
      return false;
    }

    final requestedStatus = await Permission.camera.request();
    if (requestedStatus.isGranted) {
      _isPermissionPermanentlyDenied = false;
      return true;
    }

    _isPermissionPermanentlyDenied =
        requestedStatus.isPermanentlyDenied || requestedStatus.isRestricted;
    return false;
  }

  Future<void> _capturePhoto() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) return;

    setState(() => _isCapturing = true);
    try {
      final image = await controller.takePicture();
      if (!mounted) return;
      setState(() {
        _lastImagePath = image.path;
      });
      await _goToSubmitCapture(image.path);
    } on CameraException catch (error) {
      if (!mounted) return;
      _showSnackBar(error.description ?? 'Failed to capture photo.');
    } finally {
      if (mounted) {
        setState(() => _isCapturing = false);
      }
    }
  }

  Future<void> _openGallery() async {
    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage == null || !mounted) return;
      setState(() => _lastImagePath = pickedImage.path);
      await _goToSubmitCapture(pickedImage.path);
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Unable to open gallery.');
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length <= 1 || _isInitializing) return;
    final nextIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _initializeCamera(startIndex: nextIndex);
  }

  Future<void> _goToSubmitCapture(String imagePath) async {
    final oldController = _controller;
    _controller = null;
    await oldController?.dispose();
    if (!mounted) return;
    await Navigator.pushNamed(context, '/submit-capture', arguments: imagePath);
    if (!mounted) return;
    unawaited(_initializeCamera(startIndex: _selectedCameraIndex));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final frameWidth = (media.width - 74).clamp(280.0, 340.0);
    final frameHeight = (frameWidth * 1.52).clamp(420.0, 520.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(child: _buildCameraOrState()),
            Positioned.fill(
              child: CameraOverlayFrame(
                frameWidth: frameWidth,
                frameHeight: frameHeight,
              ),
            ),
            Positioned(
              left: 19,
              right: 19,
              top: MediaQuery.of(context).padding.top + 22,
              child: _buildTopBar(),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CameraBottomControls(
                thumbnailPath: _lastImagePath,
                onOpenGallery: _openGallery,
                onCapture: _capturePhoto,
                onSwitchCamera: _switchCamera,
                captureEnabled: !_isInitializing && _errorMessage == null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraOrState() {
    if (_isInitializing) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (_errorMessage != null) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryBimaLight),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 30),
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _initializeCamera,
                child: const Text('Retry'),
              ),
              if (_isPermissionPermanentlyDenied) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () async {
                    await openAppSettings();
                    if (!mounted) return;
                    unawaited(_initializeCamera(startIndex: _selectedCameraIndex));
                  },
                  child: const Text('Open Settings'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.previewSize!.height,
          height: controller.value.previewSize!.width,
          child: CameraPreview(controller),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ActionCircleButton(
          backgroundColor: AppColors.primaryBimaBase,
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          size: 40,
          radius: 8,
        ),
        const SizedBox(width: 6),
        const Expanded(
          child: Text(
            'Scan Stock Records',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 6),
        _ActionCircleButton(
          backgroundColor: const Color(0x59E3E8EF),
          onTap: () {
            _showSnackBar('Place the stock notes inside the frame and tap shutter.');
          },
          child: const Icon(Icons.error_outline, color: Colors.white, size: 24),
          size: 46,
          radius: 23,
        ),
      ],
    );
  }
}

class _ActionCircleButton extends StatelessWidget {
  final Color backgroundColor;
  final VoidCallback onTap;
  final Widget child;
  final double size;
  final double radius;

  const _ActionCircleButton({
    required this.backgroundColor,
    required this.onTap,
    required this.child,
    required this.size,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(radius),
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(child: child),
      ),
    );
  }
}
