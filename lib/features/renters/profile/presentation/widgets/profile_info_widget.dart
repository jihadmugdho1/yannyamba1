import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:yannyamba/core/common/styles/global_text_style.dart';
import 'package:yannyamba/core/utils/constants/app_texts.dart';
import 'package:yannyamba/core/utils/constants/colors.dart';
import 'package:yannyamba/features/common/profile/data/models/profile_model.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    super.key,
    required this.profile,
    required this.isEditing,
    required this.isSaving,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    this.onEdit,
    this.onCancel,
    this.onSave,
  });

  final Profile profile;
  final bool isEditing;
  final bool isSaving;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final VoidCallback? onEdit;
  final VoidCallback? onCancel;
  final Future<void> Function()? onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Edit Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppText.myProfile.tr,
                style: getTextStyle(
                  fontSize: 16.sp,
                  font: AppFont.supreme,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                ),
              ),
              if (isEditing)
                Row(
                  children: [
                    TextButton(
                      onPressed: isSaving ? null : onCancel,
                      child: Text(AppText.cancel.tr),
                    ),
                    SizedBox(width: 8.w),
                    ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () async {
                              if (onSave != null) {
                                await onSave!();
                              }
                            },
                      child: isSaving
                          ? SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(AppText.save.tr),
                    ),
                  ],
                )
              else
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF456DFF),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      AppText.edit.tr,
                      style: getTextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20.h),

          // Name Section
          Text(
            AppText.name.tr,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 6.h),
          isEditing
              ? TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: AppText.enterName.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                  ),
                )
              : Text(
                  profile.name.isEmpty
                      ? AppText.pleaseEnterYourName.tr
                      : profile.name,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor2,
                  ),
                ),
          SizedBox(height: 20.h),

          // Phone Number Section
          Text(
            AppText.phoneNumber.tr,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 6.h),
          isEditing
              ? TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: AppText.enterPhoneNumber.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                  ),
                )
              : Text(
                  profile.phoneNumber,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor2,
                  ),
                ),
          SizedBox(height: 20.h),

          // Email Section
          Text(
            AppText.email.tr,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
            ),
          ),
          SizedBox(height: 6.h),
          isEditing
              ? TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: AppText.enterEmailAddress.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                  ),
                )
              : Text(
                  profile.email.isEmpty
                      ? AppText.pleaseEnterYourEmail.tr
                      : profile.email,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor2,
                  ),
                ),
        ],
      ),
    );
  }
}
