import 'package:flutter/material.dart';
import 'package:retail_smb/theme/color_schema.dart';

class DashboardCardContainer extends StatelessWidget {
  final String title;
  final bool showSeeAll;
  final VoidCallback? onSeeAllTap;
  final Widget child;

  const DashboardCardContainer({
    super.key,
    required this.title,
    required this.child,
    this.showSeeAll = false,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        color: AppColors.neutralWhiteLighter,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: AppColors.primaryBimaLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              if (showSeeAll)
                GestureDetector(
                  onTap: onSeeAllTap,
                  child: const Text(
                    'See all',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: AppColors.neutralBlackLighter,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
