import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../core.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // final systemBottom = MediaQuery.of(context).systemGestureInsets.bottom;
    final media = MediaQuery.of(context);
    final systemBottom = media.padding.bottom;
    return Container(
      padding: EdgeInsets.only(
        top: 8.h,
        left: 8.w,
        right: 8.w,
        bottom: systemBottom > 0 ? systemBottom : 8.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.appBarColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        border: Border(
          top: BorderSide(width: 2.w, color: Colors.white),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _NavItem(
            iconAsset: ImagePath.homeIcon,
            label: AppText.navbarHome.tr,
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            iconAsset: ImagePath.favoriteIcon,
            label: AppText.navbarFavorites.tr,
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavItem(
            iconAsset: ImagePath.aiIcon,
            label: AppText.navbarAI.tr,
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavItem(
            iconAsset: ImagePath.profileIcon,
            label: AppText.navbarProfile.tr,
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
            isProfile: true,
          ),
          _NavItem(
            iconAsset: ImagePath.menuIcon,
            label: AppText.navbarMenu.tr,
            isSelected: currentIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String iconAsset;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isProfile;

  const _NavItem({
    required this.iconAsset,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = 22.w;
    final color = isSelected ? Colors.yellow : Colors.white;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isProfile
                ? ClipOval(
                    child: Container(
                      width: iconSize,
                      height: iconSize,
                      decoration: BoxDecoration(
                        border: isSelected
                            ? Border.all(color: Colors.yellow, width: 1.w)
                            : null,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(iconAsset, fit: BoxFit.cover),
                    ),
                  )
                : Image.asset(
                    iconAsset,
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                  ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
