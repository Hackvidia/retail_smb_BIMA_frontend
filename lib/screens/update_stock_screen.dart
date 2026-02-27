import 'package:retail_smb/screens/detection_card_widget.dart';
import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:retail_smb/theme/custom_text_style.dart';
import 'package:retail_smb/widgets/description_decoration.dart';
import 'package:retail_smb/widgets/hero_widget.dart';
import 'package:flutter/material.dart';

class UpdateStockScreen extends StatefulWidget {
  const UpdateStockScreen({super.key});

  @override
  State<UpdateStockScreen> createState() => _UpdateStockScreenState();
}

class _UpdateStockScreenState extends State<UpdateStockScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhiteLight,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSize.width(context, 0.05)),
            child: Stack(
              children: [
                HeroWidget(),
                DescriptionDecoration(content: 'Ringkasan stok kamu saat ini'),
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
                              Text(
                                'Update stok toko kamu',
                                style: AppTextStyles.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: AppSize.height(context, 0.42),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    spacing: AppSize.width(context, 0.03),
                                    children: [
                                      DetectionCardWidget(
                                        name: 'ANL ACTIFIT 3X MP GINGER 20G',
                                        unitPrice: 20833,
                                        quantity: 3,
                                        onIncrement: () {},
                                        onDecrement: () {},
                                      ),
                                      DetectionCardWidget(
                                        name: 'SUSU KENTAL MANIS COKLAT 370 GR',
                                        unitPrice: 12500,
                                        quantity: 2,
                                        onIncrement: () {},
                                        onDecrement: () {},
                                      ),
                                      DetectionCardWidget(
                                        name: 'MIE INSTAN KARI AYAM 75 GR',
                                        unitPrice: 3500,
                                        quantity: 5,
                                        onIncrement: () {},
                                        onDecrement: () {},
                                      ),
                                      DetectionCardWidget(
                                        name: 'MINYAK GORENG 1 LITER',
                                        unitPrice: 16500,
                                        quantity: 4,
                                        onIncrement: () {},
                                        onDecrement: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: AppSize.width(context, 0.04),
                                children: [
                                  Text(
                                    'This is just an initial summary dari BIMA for you. BIMA will become more accurate as more data is added',
                                    style: TextStyle(
                                      fontSize: AppSize.width(context, 0.035),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  // simpan button
                                  Container(
                                    alignment: Alignment.center,
                                    width: AppSize.width(context, 0.79),
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
                                      onPressed: () {
                                        print('hallo world');
                                      },
                                      child: Text(
                                        'Lanjutkan',
                                        style: AppTextStyles.button,
                                        textAlign: TextAlign.center,
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
