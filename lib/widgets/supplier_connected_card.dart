import 'package:retail_smb/theme/color_schema.dart';
import 'package:flutter/material.dart';

class SupplierConnectedCard extends StatelessWidget {
  final String name;
  final String phone;
  final bool isChecked;
  final ValueChanged<bool>? onChanged;

  const SupplierConnectedCard({
    super.key,
    required this.name,
    required this.phone,
    required this.isChecked,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!isChecked),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.neutralWhiteLighter,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isChecked
                ? AppColors.primaryBimaBase
                : AppColors.neutralWhiteBase,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color:
                    isChecked ? AppColors.primaryBimaBase : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isChecked
                      ? AppColors.primaryBimaBase
                      : AppColors.neutralGreyDark,
                  width: 1,
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
            const SizedBox(width: 17),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    phone,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: AppColors.neutralGreyDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
