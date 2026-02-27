import 'package:flutter/material.dart';
import 'package:retail_smb/theme/color_schema.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      decoration: const BoxDecoration(
        color: AppColors.neutralWhiteLighter,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        border: Border.fromBorderSide(BorderSide(color: Color(0x1A000000))),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavItem(
              icon: Icons.home_outlined,
              label: 'Home',
              isActive: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.check_circle_outline,
              label: 'Insight',
              isActive: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              isActive: currentIndex == 2,
              onTap: () => onTap(2),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? AppColors.primaryMidnightBase
        : AppColors.neutralBlackLighter;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 74,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                height: 1.5,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              height: 2,
              width: 50,
              color: isActive ? AppColors.primaryMidnightBase : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
