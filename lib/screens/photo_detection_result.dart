import 'package:retail_smb/screens/detection_card_widget.dart';
import 'package:retail_smb/models/detection_result_item.dart';
import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/widgets/description_decoration.dart';
import 'package:retail_smb/widgets/hero_widget.dart';
import 'package:flutter/material.dart';

class PhotoDetectionResult extends StatefulWidget {
  const PhotoDetectionResult({super.key});

  @override
  State<PhotoDetectionResult> createState() => _PhotoDetectionResultState();
}

class _PhotoDetectionResultState extends State<PhotoDetectionResult> {
  List<DetectionResultItem> _detectedItems = const [];
  final List<TextEditingController> _nameControllers = [];
  bool _isInitialized = false;
  bool _isEditMode = false;
  bool _isSaved = false;

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
    if (args is PhotoDetectionArgs && args.detectedItems.isNotEmpty) {
      _detectedItems = List<DetectionResultItem>.from(args.detectedItems);
    } else {
      _detectedItems = _buildDummyDetections();
    }

    _syncNameControllersWithItems();
  }

  void _incrementQuantity(int index) {
    if (_isSaved) return;
    final item = _detectedItems[index];
    setState(() {
      _detectedItems[index] = item.copyWith(quantity: item.quantity + 1);
    });
  }

  void _decrementQuantity(int index) {
    if (_isSaved) return;
    final item = _detectedItems[index];
    if (item.quantity <= 1) return;
    setState(() {
      _detectedItems[index] = item.copyWith(quantity: item.quantity - 1);
    });
  }

  void _updateName(int index, String name) {
    setState(() {
      _detectedItems[index] = _detectedItems[index].copyWith(name: name);
    });
  }

  void _syncNameControllersWithItems() {
    if (_nameControllers.length > _detectedItems.length) {
      final extraControllers = _nameControllers.sublist(_detectedItems.length);
      for (final controller in extraControllers) {
        controller.dispose();
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
      DetectionResultItem(
        id: 'item-3',
        name: 'MINYAK GORENG 1 LITER',
        unitPrice: 16500,
        quantity: 4,
      ),
    ];
  }

  void _onEditData() {
    if (_isSaved) return;
    setState(() {
      _isEditMode = true;
    });
  }

  void _onSaveData() {
    setState(() {
      _isEditMode = false;
      _isSaved = true;
    });
  }

  void _onContinue() {
    Navigator.pushReplacementNamed(context, '/before-dashboard');
  }

  @override
  Widget build(BuildContext context) {
    _syncNameControllersWithItems();

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
                            border: Border.all(
                              color: AppColors.primaryBimaLight,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppSize.width(context, 0.018),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _isSaved
                                    ? 'Update your shop stock'
                                    : 'Confirmation your update shop stock',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: AppSize.width(context, 0.065),
                                  fontWeight: FontWeight.w500,
                                  height: 1.45,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: AppSize.height(context, 0.02)),
                              Expanded(
                                child: _detectedItems.isEmpty
                                    ? Center(
                                        child: Text(
                                          'No detected item found.',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize:
                                                AppSize.width(context, 0.038),
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
                                            showQuantityControls: !_isSaved,
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
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                                height: AppSize.height(
                                                    context, 0.012)),
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
                                          border: Border.all(
                                            color: AppColors.primaryBimaBase,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            AppSize.width(context, 0.02),
                                          ),
                                        ),
                                        child: TextButton(
                                          onPressed: _onEditData,
                                          child: Text(
                                            'Edit data',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize:
                                                  AppSize.width(context, 0.045),
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primaryBimaBase,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width: AppSize.width(context, 0.025)),
                                    Expanded(
                                      child: Container(
                                        height: AppSize.height(context, 0.06),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryBimaBase,
                                          border: Border.all(
                                            color: AppColors.primaryBimaBase,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            AppSize.width(context, 0.02),
                                          ),
                                        ),
                                        child: TextButton(
                                          onPressed: _onSaveData,
                                          child: Text(
                                            'Save data',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize:
                                                  AppSize.width(context, 0.045),
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.neutralWhiteLighter,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              else ...[
                                SizedBox(height: AppSize.height(context, 0.02)),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: AppSize.width(context, 0.042),
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.neutralBlackBase,
                                      height: 1.5,
                                    ),
                                    children: const [
                                      TextSpan(text: 'This is just '),
                                      TextSpan(
                                        text: 'an initial summary',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryBimaDark,
                                        ),
                                      ),
                                      TextSpan(text: ' dari BIMA for you. BIMA will '),
                                      TextSpan(
                                        text: 'become more accurate as more data is added',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryBimaDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: AppSize.height(context, 0.02)),
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
