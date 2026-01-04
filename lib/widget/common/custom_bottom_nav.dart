import 'package:flutter/material.dart';

import '../../utils/color.dart';


class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.view_quilt_outlined, Icons.view_quilt),
              _buildNavItem(1, Icons.account_tree_outlined, Icons.account_tree),
              _buildNavItem(2, Icons.calendar_month_outlined, Icons.calendar_month),
              _buildNavItem(3, Icons.chat_outlined, Icons.chat_bubble),
              _buildNavItem(4, Icons.account_circle_outlined, Icons.account_circle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlinedIcon, IconData filledIcon) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Icon(
          isSelected ? filledIcon : outlinedIcon,
          color: isSelected ? AppColors.primary : AppColors.navInactive,
          size: 24,
        ),
      ),
    );
  }
}
