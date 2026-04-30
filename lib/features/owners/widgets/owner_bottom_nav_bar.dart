import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Reusable bottom navigation bar for owner dashboard
class OwnerBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const OwnerBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                icon: Iconsax.home,
                index: 0,
                isActive: currentIndex == 0,
              ),
              _buildNavItem(
                icon: Iconsax.building,
                index: 1,
                isActive: currentIndex == 1,
              ),
              _buildNavItem(
                icon: Iconsax.add_square,
                index: 2,
                isActive: currentIndex == 2,
              ),
              _buildNavItem(
                icon: Iconsax.user,
                index: 3,
                isActive: currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: isActive
              ? BoxDecoration(
                  color: const Color(0xFFF2F4F8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1.5,
                  ),
                )
              : null,
          child: Icon(
            icon,
            size: 22,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}
