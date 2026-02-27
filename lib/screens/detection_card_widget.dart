import 'package:retail_smb/theme/app_sizing.dart';
import 'package:retail_smb/theme/color_schema.dart';
import 'package:flutter/material.dart';

class DetectionCardWidget extends StatelessWidget {
  final String name;
  final int unitPrice;
  final int quantity;
  final String unitLabel;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isNameEditable;
  final bool showQuantityControls;
  final TextEditingController? nameController;
  final ValueChanged<String>? onNameChanged;

  const DetectionCardWidget({
    super.key,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.unitLabel = 'RENCENG',
    this.isNameEditable = false,
    this.showQuantityControls = true,
    this.nameController,
    this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice = unitPrice * quantity;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width(context, 0.035),
        vertical: AppSize.width(context, 0.03),
      ),
      decoration: BoxDecoration(
        color: AppColors.neutralWhiteLighter,
        border: Border.all(color: AppColors.primaryBimaLight),
        borderRadius: BorderRadius.circular(AppSize.width(context, 0.014)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNameEditable && nameController != null)
                  TextField(
                    controller: nameController,
                    onChanged: onNameChanged,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: AppSize.width(context, 0.041),
                      height: 1.45,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    maxLines: 3,
                    minLines: 1,
                  )
                else
                  Text(
                    name,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: AppSize.width(context, 0.041),
                      height: 1.45,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                SizedBox(height: AppSize.height(context, 0.004)),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: AppSize.width(context, 0.033),
                      fontWeight: FontWeight.w400,
                      color: AppColors.neutralBlackDark,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: '$quantity $unitLabel, '),
                      TextSpan(
                        text: _formatRupiah(unitPrice),
                        style: const TextStyle(color: AppColors.systemErrorRedBase),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSize.width(context, 0.03)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (showQuantityControls)
                Row(
                  children: [
                    _StepButton(
                      icon: Icons.remove,
                      onTap: onDecrement,
                    ),
                    _QuantityBox(quantity: quantity),
                    _StepButton(
                      icon: Icons.add,
                      onTap: onIncrement,
                    ),
                  ],
                )
              else
                _QuantityBox(quantity: quantity),
              SizedBox(height: AppSize.height(context, 0.004)),
              Text(
                _formatRupiah(totalPrice),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: AppSize.width(context, 0.033),
                  fontWeight: FontWeight.w400,
                  color: AppColors.systemErrorRedBase,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatRupiah(int value) {
    final text = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final positionFromRight = text.length - i;
      buffer.write(text[i]);
      if (positionFromRight > 1 && positionFromRight % 3 == 1) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString()}';
  }
}

class _QuantityBox extends StatelessWidget {
  final int quantity;

  const _QuantityBox({required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.width(context, 0.105),
      height: AppSize.width(context, 0.06),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryBimaBase),
        color: AppColors.neutralWhiteLighter,
      ),
      child: Text(
        '$quantity',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: AppSize.width(context, 0.03),
          color: AppColors.primaryBimaBase,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: AppSize.width(context, 0.054),
        height: AppSize.width(context, 0.06),
        decoration: BoxDecoration(
          color: AppColors.primaryBimaLighter,
          border: Border.all(color: AppColors.primaryBimaBase),
        ),
        child: Icon(
          icon,
          size: AppSize.width(context, 0.035),
          color: AppColors.primaryBimaBase,
        ),
      ),
    );
  }
}
