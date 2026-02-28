import 'package:flutter/material.dart';
import 'package:retail_smb/models/detection_result_item.dart';
import 'package:retail_smb/screens/detection_card_widget.dart';
import 'package:retail_smb/services/document_extract_service.dart';
import 'package:retail_smb/state/app_session_state.dart';
import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/description_decoration.dart';
import 'package:retail_smb/widgets/hero_widget.dart';

class PhotoDetectionResult extends StatefulWidget {
  const PhotoDetectionResult({super.key});

  @override
  State<PhotoDetectionResult> createState() => _PhotoDetectionResultState();
}

class _PhotoDetectionResultState extends State<PhotoDetectionResult> {
  final List<TextEditingController> _nameControllers = [];
  final Set<String> _manualItemIds = <String>{};
  final DocumentExtractService _extractService = DocumentExtractService();

  List<DetectionResultItem> _detectedItems = const [];
  bool _isInitialized = false;
  bool _isEditMode = false;
  bool _isSaved = false;
  bool _isSaving = false;
  bool _isLoadingReview = false;
  String? _extractionId;
  String? _confirmEndpoint;
  String? _manualAddEndpoint;

  @override
  void dispose() {
    for (final controller in _nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    _isInitialized = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is PhotoDetectionArgs) {
      _detectedItems = List<DetectionResultItem>.from(args.detectedItems);
      _extractionId = args.extractionId;
      _confirmEndpoint = args.confirmEndpoint;
      _manualAddEndpoint = args.manualAddEndpoint;
      final endpoint = args.confirmEndpoint?.trim();
      final extractionId = args.extractionId?.trim();
      if (endpoint != null &&
          extractionId != null &&
          _extractService.isStockBoxesConfirmEndpoint(endpoint) &&
          extractionId.isNotEmpty) {
        _loadStockBoxReview(extractionId);
      }
    } else {
      _detectedItems = _buildDummyDetections();
    }
    _syncNameControllersWithItems();
  }

  Future<void> _loadStockBoxReview(String extractionId) async {
    if (_isLoadingReview) return;
    setState(() => _isLoadingReview = true);
    try {
      await AppSessionState.instance.hydrate();
      final token = AppSessionState.instance.authToken;
      if (token == null || token.trim().isEmpty) return;
      final items = await _extractService.fetchStockBoxReview(
        extractionId: extractionId,
        token: token,
      );
      if (!mounted || items.isEmpty) return;
      setState(() {
        _detectedItems = items
            .map(
              (e) => DetectionResultItem(
                id: e.id,
                name: e.name,
                unitPrice: e.unitPrice,
                quantity: e.quantity,
                unitLabel: e.unitLabel,
                sourceNames: e.sourceNames,
              ),
            )
            .toList();
      });
      _syncNameControllersWithItems();
    } catch (_) {
      // Keep extracted items as fallback when review GET fails.
    } finally {
      if (mounted) setState(() => _isLoadingReview = false);
    }
  }

  void _incrementQuantity(int index) {
    if (!_isEditMode || _isSaved) return;
    final item = _detectedItems[index];
    setState(() {
      _detectedItems[index] = item.copyWith(quantity: item.quantity + 1);
    });
  }

  void _decrementQuantity(int index) {
    if (!_isEditMode || _isSaved) return;
    final item = _detectedItems[index];
    if (item.quantity <= 1) return;
    setState(() {
      _detectedItems[index] = item.copyWith(quantity: item.quantity - 1);
    });
  }

  void _updateName(int index, String name) {
    if (!_isEditMode || _isSaved) return;
    setState(() {
      _detectedItems[index] = _detectedItems[index].copyWith(name: name);
    });
  }

  void _syncNameControllersWithItems() {
    if (_nameControllers.length > _detectedItems.length) {
      final extras = _nameControllers.sublist(_detectedItems.length);
      for (final c in extras) {
        c.dispose();
      }
      _nameControllers.removeRange(_detectedItems.length, _nameControllers.length);
    }
    while (_nameControllers.length < _detectedItems.length) {
      _nameControllers.add(
        TextEditingController(text: _detectedItems[_nameControllers.length].name),
      );
    }
    for (int i = 0; i < _detectedItems.length; i++) {
      final expected = _detectedItems[i].name;
      if (_nameControllers[i].text != expected) {
        _nameControllers[i].text = expected;
      }
    }
  }

  List<DetectionResultItem> _buildDummyDetections() {
    return const [
      DetectionResultItem(
        id: 'item-1',
        name: 'ANL ACTIFIT 3X MP GINGER 20G (12X10 SACHET)',
        unitPrice: 20833,
        quantity: 3,
      ),
      DetectionResultItem(
        id: 'item-2',
        name: 'GULA PASIR KEMASAN 1 KG',
        unitPrice: 14000,
        quantity: 2,
      ),
    ];
  }

  void _onEditData() {
    if (_isSaved || _isSaving) return;
    setState(() {
      _isEditMode = true;
    });
  }

  Future<void> _onAddManualItem() async {
    if (!_isEditMode || _isSaving) return;
    final nameController = TextEditingController();
    final qtyController = TextEditingController(text: '1');
    final uomController = TextEditingController(text: 'BOX');

    final result = await showDialog<DetectionResultItem>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Stock Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item name'),
              ),
              TextField(
                controller: qtyController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: uomController,
                decoration: const InputDecoration(labelText: 'UOM'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final qty = int.tryParse(qtyController.text.trim()) ?? 1;
                final uom = uomController.text.trim().isEmpty
                    ? 'BOX'
                    : uomController.text.trim();
                if (name.isEmpty || qty <= 0) return;
                Navigator.pop(
                  context,
                  DetectionResultItem(
                    id: 'manual-${DateTime.now().millisecondsSinceEpoch}',
                    name: name,
                    unitPrice: null,
                    quantity: qty,
                    unitLabel: uom,
                  ),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (!mounted || result == null) return;
    setState(() {
      _detectedItems = [..._detectedItems, result];
      _manualItemIds.add(result.id);
    });
    _syncNameControllersWithItems();
  }

  Future<void> _onSaveData() async {
    if (_isSaving) return;
    final extractionId = _extractionId?.trim();
    final confirmEndpoint = _confirmEndpoint?.trim();
    final manualAddEndpoint = _manualAddEndpoint?.trim();
    final isStockFlow = confirmEndpoint != null &&
        _extractService.isStockBoxesConfirmEndpoint(confirmEndpoint);
    if (extractionId == null ||
        extractionId.isEmpty ||
        confirmEndpoint == null ||
        confirmEndpoint.isEmpty ||
        (!isStockFlow && (manualAddEndpoint == null || manualAddEndpoint.isEmpty))) {
      _showSnack('Extraction context is missing. Please capture again.');
      return;
    }

    setState(() => _isSaving = true);
    try {
      await AppSessionState.instance.hydrate();
      final token = AppSessionState.instance.authToken;
      if (token == null || token.trim().isEmpty) {
        _showSnack('Session expired. Please login again.');
        return;
      }

      if (!isStockFlow) {
        for (final item in _detectedItems.where((e) => _manualItemIds.contains(e.id))) {
          final result = await _extractService.addManualExtractionItem(
            endpoint: manualAddEndpoint!,
            token: token,
            displayName: item.name,
            qty: item.quantity,
            uom: item.unitLabel,
          );
          if (!result.success) {
            _showSnack(result.message ?? 'Failed to add manual item.');
            return;
          }
        }
      }

      final payloadItems = _detectedItems
          .map(
            (e) => CameraExtractionItem(
              id: e.id,
              name: e.name,
              quantity: e.quantity,
              unitLabel: e.unitLabel,
              unitPrice: e.unitPrice,
              sourceNames: e.sourceNames,
            ),
          )
          .toList();

      final shouldPatchStockReview = isStockFlow && _isEditMode;
      if (shouldPatchStockReview) {
        final patchResult = await _extractService.patchStockBoxReview(
          extractionId: extractionId,
          token: token,
          items: payloadItems,
        );
        if (!patchResult.success) {
          _showSnack(patchResult.message ?? 'Failed to patch stock box review.');
          return;
        }
      }

      final confirmResult = await _extractService.confirmCameraExtraction(
        endpoint: confirmEndpoint,
        token: token,
        extractionId: extractionId,
        items: payloadItems,
      );
      if (!confirmResult.success) {
        _showSnack(confirmResult.message ?? 'Failed to save data.');
        return;
      }

      setState(() {
        _isEditMode = false;
        _isSaved = true;
      });
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _onContinue() {
    Navigator.pushReplacementNamed(context, '/before-dashboard');
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    _syncNameControllersWithItems();

    final headerTitle = _isEditMode
        ? 'Update your shop stock'
        : 'Confirmation your update shop stock';

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
                  content: 'The results of reading your stock records!',
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
                            color: const Color(0xFFFEFEFF),
                            border: Border.all(color: AppColors.primaryBimaLight),
                            borderRadius: BorderRadius.circular(
                              AppSize.width(context, 0.018),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                headerTitle,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: AppSize.width(context, 0.065),
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: AppSize.height(context, 0.02)),
                              if (_isEditMode)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: _isSaving ? null : _onAddManualItem,
                                    child: const Text('Add item'),
                                  ),
                                ),
                              Expanded(
                                child: _detectedItems.isEmpty
                                    ? Center(
                                        child: Text(
                                          'No detected item found.',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: AppSize.width(context, 0.038),
                                            color: AppColors.neutralBlackLight,
                                          ),
                                        ),
                                      )
                                    : ListView.separated(
                                        itemCount: _detectedItems.length,
                                        itemBuilder: (context, index) {
                                          final item = _detectedItems[index];
                                          return DetectionCardWidget(
                                            name: item.name,
                                            unitPrice: item.unitPrice,
                                            quantity: item.quantity,
                                            unitLabel: item.unitLabel,
                                            isNameEditable: _isEditMode,
                                            showQuantityControls: _isEditMode,
                                            nameController: index < _nameControllers.length
                                                ? _nameControllers[index]
                                                : null,
                                            onNameChanged: (value) =>
                                                _updateName(index, value),
                                            onIncrement: () =>
                                                _incrementQuantity(index),
                                            onDecrement: () =>
                                                _decrementQuantity(index),
                                          );
                                        },
                                        separatorBuilder: (_, __) =>
                                            SizedBox(height: AppSize.height(context, 0.012)),
                                      ),
                              ),
                              SizedBox(height: AppSize.height(context, 0.02)),
                              if (!_isSaved)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: AppSize.height(context, 0.06),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.primaryBimaBase),
                                          borderRadius: BorderRadius.circular(
                                            AppSize.width(context, 0.02),
                                          ),
                                        ),
                                        child: TextButton(
                                          onPressed: _isSaving ? null : _onEditData,
                                          child: Text(
                                            'Edit data',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: AppSize.width(context, 0.045),
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primaryBimaBase,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: AppSize.width(context, 0.025)),
                                    Expanded(
                                      child: Container(
                                        height: AppSize.height(context, 0.06),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryBimaBase,
                                          border: Border.all(color: AppColors.primaryBimaBase),
                                          borderRadius: BorderRadius.circular(
                                            AppSize.width(context, 0.02),
                                          ),
                                        ),
                                        child: TextButton(
                                          onPressed: _isSaving ? null : _onSaveData,
                                          child: Text(
                                            _isSaving ? 'Saving...' : 'Save data',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: AppSize.width(context, 0.045),
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.neutralWhiteLighter,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else
                                SizedBox(
                                  width: double.infinity,
                                  height: AppSize.height(context, 0.06),
                                  child: ElevatedButton(
                                    onPressed: _onContinue,
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: AppColors.primaryBimaBase,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          AppSize.width(context, 0.02),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'Continue',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: AppSize.width(context, 0.05),
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.neutralWhiteLighter,
                                      ),
                                    ),
                                  ),
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
