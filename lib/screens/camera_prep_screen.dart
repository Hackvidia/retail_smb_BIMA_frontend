import 'package:flutter/material.dart';
import 'package:retail_smb/models/capture_flow_args.dart';
import 'package:retail_smb/state/app_session_state.dart';
import 'package:retail_smb/theme/color_schema.dart';

class CameraPrepScreen extends StatefulWidget {
  const CameraPrepScreen({super.key});

  @override
  State<CameraPrepScreen> createState() => _CameraPrepScreenState();
}

class _CameraPrepScreenState extends State<CameraPrepScreen> {
  static const List<String> _stockDocumentTypes = <String>[
    'Shelves or stacks of items',
    'Supplier note/invoice',
  ];

  String? _selectedDocumentType;
  bool _isInitialized = false;
  CameraPrepArgs _flowArgs = const CameraPrepArgs();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    _isInitialized = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is CameraPrepArgs) {
      _flowArgs = args;
    }
  }

  void _onUploadPhotos() {
    final selectedType = _selectedDocumentType;
    if (selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select stock document type.')),
      );
      return;
    }

    AppSessionState.instance.setCurrentStockAction(_flowArgs.action);

    Navigator.pushNamed(
      context,
      '/scan-camera',
      arguments: ScanCameraArgs(
        markFirstInputOnUsePhoto: _flowArgs.markFirstInputOnUsePhoto,
        action: _flowArgs.action,
        stockDocumentType: selectedType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EBED),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 412,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          child: Center(
                            child: Container(
                              width: 360,
                              height: 400,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryBimaLighter,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            _buildTopBubble(),
                            const SizedBox(height: 18),
                            _buildMainCard(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBubble() {
    return SizedBox(
      height: 90,
      child: Stack(
        children: [
          Positioned(
            left: 114,
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF081A1D),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'BIMA can read various\ntypes of photos',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: AppColors.neutralWhiteLighter,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 15,
            child: Image.asset(
              'assets/images/bima-icon.png',
              width: 95,
              height: 95,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard() {
    final canSubmit = _selectedDocumentType != null;

    return Container(
      width: 361,
      padding: const EdgeInsets.fromLTRB(18, 26, 18, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF9CC7CF)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: double.infinity,
            child: Text(
              'Clear photos help BIMA\nunderstand your stock',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 40 / 2,
                fontWeight: FontWeight.w500,
                height: 1.5,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Stock document types',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              color: Color(0xFF011829),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD4D4D8)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D101828),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedDocumentType,
                hint: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Select document types',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFA1A1AA),
                    ),
                  ),
                ),
                icon: const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child:
                      Icon(Icons.keyboard_arrow_down, color: Color(0xFFA1A1AA)),
                ),
                items: _stockDocumentTypes
                    .map(
                      (type) => DropdownMenuItem<String>(
                        value: type,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            type,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF011829),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedDocumentType = value);
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Recommended document resolution:',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: _RecommendationCard(
                  title: 'Shelves or stacks of items',
                  subtitle: 'Item information is clearly visible',
                  imagePath: 'assets/images/shelves-photo.png',
                ),
              ),
              SizedBox(width: 9),
              Expanded(
                child: _RecommendationCard(
                  title: 'Supplier note/invoice',
                  subtitle: 'Item information is clearly visible',
                  imagePath: 'assets/images/supplier-invoice.png',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'What is not recommended:',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(
                child: _NotRecommendedItem(
                  label: 'Photos are too dark and blurry',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _NotRecommendedItem(label: 'Closed item'),
              ),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: canSubmit ? _onUploadPhotos : null,
              icon: const Icon(Icons.photo_camera_outlined, size: 20),
              label: const Text(
                'Upload Photos',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: canSubmit
                    ? AppColors.primaryBimaBase
                    : const Color(0xFFE9EBED),
                foregroundColor: AppColors.neutralWhiteLighter,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const _RecommendationCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 202,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFC3DFE4),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 113,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Positioned(
                  top: 5,
                  left: 5,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Color(0xFF298191),
                    child: Icon(Icons.check, size: 13, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotRecommendedItem extends StatelessWidget {
  final String label;

  const _NotRecommendedItem({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: CircleAvatar(
            radius: 10,
            backgroundColor: Color(0xFFE42B3B),
            child: Icon(Icons.close, size: 14, color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
