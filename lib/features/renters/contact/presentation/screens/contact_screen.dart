import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import '../../controllers/contact_controller.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContactController());

    return Scaffold(
      appBar: CustomAppBar(
        title: AppText.contactUs.tr,
        centerTitle: true,
        showBackButton: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.support_agent,
                size: 36.w,
                color: AppColors.primaryBlue,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              AppText.needHelp.tr,
              style: getTextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              AppText.contactSupportViaWhatsApp.tr,
              style: getTextStyle(fontSize: 10.sp, color: AppColors.textColor2),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, color: AppColors.primaryBlue, size: 24.w),
                  SizedBox(width: 12.w),
                  Text(
                    '+237 6XX XXX XXX',
                    style: getTextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => controller.contactSupportViaWhatsApp(context),
                icon: Image.asset(
                  ImagePath.whatsappIcon,
                  height: 16.h,
                  width: 16.w,
                ),
                label: Text(
                  AppText.whatsapp.tr,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              AppText.supportAvailability.tr,
              style: getTextStyle(fontSize: 10.sp, color: AppColors.textColor2),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
