import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import '../../../../../../core/core.dart';

class ComingSoonCard extends StatelessWidget {
  const ComingSoonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: const Color(0xFFF3F4F6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_empty_rounded,
                size: 36.sp,
                color: AppColors.primaryBlue,
              ),
              SizedBox(height: 10.h),
              Text(
                AppText.normalApartmentsAreComingSoon.tr,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                AppText.normalApartmentsPrepare.tr,
                textAlign: TextAlign.center,
                style: getTextStyle(
                  fontSize: 8.sp,
                  color: AppColors.textColor2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
