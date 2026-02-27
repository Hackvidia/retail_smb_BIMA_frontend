import 'package:flutter/material.dart';
import 'package:retail_smb/models/operational_document_item.dart';
import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';

class OperationalDocumentsScreen extends StatefulWidget {
  const OperationalDocumentsScreen({super.key});

  @override
  State<OperationalDocumentsScreen> createState() =>
      _OperationalDocumentsScreenState();
}

class _OperationalDocumentsScreenState
    extends State<OperationalDocumentsScreen> {
  static const List<String> _documentTypes = [
    'Daily sales',
    'Product price list',
    'Operational expenditures',
    'Capital expenditures',
  ];

  final List<OperationalDocumentItem> _uploadedDocuments = [];
  String? _selectedType;
  bool _isDropdownOpen = false;

  bool get _hasUploadedDocs => _uploadedDocuments.isNotEmpty;

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
  }

  void _selectType(String type) {
    setState(() {
      _selectedType = type;
      _isDropdownOpen = false;
    });
  }

  void _uploadDocument() {
    final type = _selectedType;
    if (type == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select operational document type.')),
      );
      return;
    }

    final fileNumber =
        _uploadedDocuments.where((doc) => doc.type == type).length + 1;
    final fileName = _buildFileName(type, fileNumber);
    final fileSizeMb = 16.5 + fileNumber * 1.8;

    setState(() {
      _uploadedDocuments.add(
        OperationalDocumentItem(
          type: type,
          fileName: fileName,
          sizeLabel: '${fileSizeMb.toStringAsFixed(2).replaceAll('.', ',')} MB',
        ),
      );
      _isDropdownOpen = false;
    });
  }

  String _buildFileName(String type, int index) {
    switch (type) {
      case 'Daily sales':
        return 'Daily Sales Report ${index.toString().padLeft(2, '0')}.doc';
      case 'Product price list':
        return index == 1
            ? 'Pricelist Bulan Januari.doc'
            : 'Pricelist Bulan ${index + 1}.doc';
      case 'Operational expenditures':
        return 'Operational Cost ${index.toString().padLeft(2, '0')}.doc';
      case 'Capital expenditures':
        return 'Capital Expenditures ${index.toString().padLeft(2, '0')}.doc';
      default:
        return 'Operational Document $index.doc';
    }
  }

  void _removeDocument(int index) {
    setState(() {
      _uploadedDocuments.removeAt(index);
    });
  }

  void _useDocuments() {
    Navigator.pushNamed(
      context,
      '/operational-documents-summary',
      arguments: OperationalDocumentsSummaryArgs(
        uploadedDocuments: List<OperationalDocumentItem>.from(_uploadedDocuments),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhiteLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: SizedBox(
              width: 370,
              child: Stack(
                children: [
                  Positioned(
                    left: 18,
                    child: Container(
                      width: 330,
                      height: 330,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBimaLighter,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: _buildBubbleAndMascot(),
                  ),
                  if (_hasUploadedDocs)
                    Positioned(
                      left: 12,
                      child: _buildBackButton(),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: _buildMainContainer(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBubbleAndMascot() {
    return Row(
      children: [
        SizedBox(
          width: 108,
          child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/images/bima-icon.png',
              width: 95,
              height: 95,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.primaryBimaDarker,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _hasUploadedDocs
                  ? 'Double check the document you took'
                  : 'BIMA can analyze your sales, pricing, and cost records',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.25,
                color: AppColors.neutralWhiteLighter,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryBimaBase,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D101828),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildMainContainer() {
    return Container(
      width: 361,
      height: _hasUploadedDocs
          ? AppSize.screenHeight(context) * 0.6
          : AppSize.screenHeight(context) * 0.65,
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
      decoration: BoxDecoration(
        color: AppColors.neutralWhiteLighter,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.primaryBimaLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_hasUploadedDocs)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              child: Center(
                child: Text(
                  'Help BIMA to know your operational records!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          const Text(
            'Operational document types',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 20 / 14,
              color: Color(0xFF011829),
            ),
          ),
          const SizedBox(height: 6),
          _buildDropdownField(),
          if (_isDropdownOpen) ...[
            const SizedBox(height: 8),
            _buildDropdownMenu(),
          ],
          const SizedBox(height: 14),
          if (_hasUploadedDocs)
            Expanded(
              child: ListView.separated(
                itemCount: _uploadedDocuments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final doc = _uploadedDocuments[index];
                  return _buildUploadedCard(doc, index);
                },
              ),
            )
          else
            const Spacer(),
          if (_hasUploadedDocs)
            Row(
              children: [
                Expanded(
                  child: _outlinedButton(
                    label: 'Add more',
                    onTap: _uploadDocument,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _filledButton(
                    label: 'Continue',
                    onTap: _useDocuments,
                    icon: null,
                  ),
                ),
              ],
            )
          else
            _filledButton(
              label: 'Upload Document',
              onTap: _uploadDocument,
              icon: const Icon(
                Icons.folder,
                size: 20,
                color: AppColors.neutralWhiteLighter,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdownField() {
    return InkWell(
      onTap: _toggleDropdown,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hasUploadedDocs
                ? AppColors.primaryBimaBase
                : const Color(0xFF7EC9FB),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D101828),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedType ?? 'Select document types',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight:
                      _selectedType == null ? FontWeight.w400 : FontWeight.w500,
                  height: 1.5,
                  color: const Color(0xFF011829),
                ),
              ),
            ),
            Icon(
              _isDropdownOpen
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 24,
              color: const Color(0xFFA1A1AA),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownMenu() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF2F4F7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14101828),
            blurRadius: 16,
            spreadRadius: -4,
            offset: Offset(0, 12),
          ),
          BoxShadow(
            color: Color(0x08101828),
            blurRadius: 6,
            spreadRadius: -2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _documentTypes.map((type) {
          final isSelected = type == _selectedType;
          return InkWell(
            onTap: () => _selectType(type),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              color: isSelected ? const Color(0xFFF4F4F5) : Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      type,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: Color(0xFF011829),
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check,
                      size: 24,
                      color: Color(0xFF1093E7),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUploadedCard(OperationalDocumentItem doc, int index) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.primaryBimaBase),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Color(0xFF121926),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  doc.sizeLabel,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Color(0xFF625B71),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _removeDocument(index),
            borderRadius: BorderRadius.circular(5),
            child: const SizedBox(
              width: 34,
              height: 34,
              child: Icon(Icons.close, size: 24, color: Color(0xFF121926)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filledButton({
    required String label,
    required VoidCallback onTap,
    required Widget? icon,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBimaBase,
          foregroundColor: AppColors.neutralWhiteLighter,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon,
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 28 / 2,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _outlinedButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryBimaBase),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 28 / 2,
            fontWeight: FontWeight.w500,
            height: 1.5,
            color: AppColors.primaryBimaBase,
          ),
        ),
      ),
    );
  }
}
