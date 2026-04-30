import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import '../../controllers/add_property_controller.dart';

class LeaseTakeoverToggle extends StatelessWidget {
  final AddPropertyController controller;
  const LeaseTakeoverToggle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4).w,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lease Takeover',
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor,
              ),
            ),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: controller.isLeaseTakeover.value,
                onChanged: (value) => controller.isLeaseTakeover.value = value,
                activeThumbColor: const Color(0xFF2196F3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
