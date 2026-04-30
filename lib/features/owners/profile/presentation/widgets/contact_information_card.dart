import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/common/profile/data/models/profile_model.dart';

/// Widget displaying contact information with edit functionality
class ContactInformationCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback onEditPressed;

  const ContactInformationCard({
    super.key,
    required this.profile,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppText.contactInformation.tr,
                style: getTextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColor,
                  font: AppFont.supreme,
                ),
              ),
              InkWell(
                onTap: onEditPressed,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    AppText.edit.tr,
                    style: getTextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildInfoItem(
            label: AppText.phoneNumber.tr,
            value: profile.phoneNumber,
          ),
          SizedBox(height: 16.h),
          _buildInfoItem(label: AppText.email.tr, value: profile.email),
        ],
      ),
    );
  }

  Widget _buildInfoItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value.isEmpty ? AppText.pleaseEnterYourEmail.tr : value,
          style: TextStyle(fontSize: 12.sp, color: AppColors.textColor2),
        ),
      ],
    );
  }
}
