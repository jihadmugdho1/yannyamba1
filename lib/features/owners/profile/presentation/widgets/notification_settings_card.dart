import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:yannyamba/core/core.dart';

/// Widget for notification settings with toggles
class NotificationSettingsCard extends StatelessWidget {
  final bool viewingRequestsEnabled;
  final bool propertyUpdatesEnabled;
  final ValueChanged<bool> onViewingRequestsChanged;
  final ValueChanged<bool> onPropertyUpdatesChanged;

  const NotificationSettingsCard({
    super.key,
    required this.viewingRequestsEnabled,
    required this.propertyUpdatesEnabled,
    required this.onViewingRequestsChanged,
    required this.onPropertyUpdatesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12).w,
      padding: EdgeInsets.all(12).h,
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
          Text(
            AppText.notificationSettings.tr,
            style: getTextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor,
              font: AppFont.supreme,
            ),
          ),
          SizedBox(height: 20.h),

          // Viewing Requests Toggle
          _buildNotificationToggle(
            title: AppText.viewingRequests.tr,
            subtitle: AppText.viewingRequestsDetails.tr,
            value: viewingRequestsEnabled,
            onChanged: onViewingRequestsChanged,
          ),

          SizedBox(height: 20.h),

          // Property Updates Toggle
          _buildNotificationToggle(
            title: AppText.propertyUpdates.tr,
            subtitle: AppText.propertyUpdatesDetails.tr,
            value: propertyUpdatesEnabled,
            onChanged: onPropertyUpdatesChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12.sp, color: AppColors.textColor2),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: const Color(0xFF4CAF50),
        ),
      ],
    );
  }
}
