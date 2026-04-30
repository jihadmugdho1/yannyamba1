import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yannyamba/core/core.dart';
import '../../controllers/furnished_apartment_controller.dart';

class DateSelectorCard extends StatelessWidget {
  DateSelectorCard({super.key});

  final FurnishedApartmentController controller =
      Get.find<FurnishedApartmentController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'When would you like to stay?',
            style: getTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  context: context,
                  label: 'Check-in',
                  icon: Icons.calendar_today,
                  date: controller.checkInDate.value,
                  onTap: () => _selectCheckInDate(context),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildDateField(
                  context: context,
                  label: 'Check-out',
                  icon: Icons.event,
                  date: controller.checkOutDate.value,
                  onTap: () => _selectCheckOutDate(context),
                ),
              ),
            ],
          ),
          Obx(() {
            if (controller.totalNights != null) {
              return Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.nights_stay_outlined,
                        size: 18.sp,
                        color: AppColors.primaryBlue,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${controller.totalNights} night${controller.totalNights! > 1 ? 's' : ''}',
                        style: getTextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          if (controller.checkInDate.value != null ||
              controller.checkOutDate.value != null)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    controller.setDates(null, null);
                  },
                  child: Text(
                    'Clear dates',
                    style: getTextStyle(
                      fontSize: 14.sp,
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required IconData icon,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: date != null
                ? AppColors.primaryBlue.withValues(alpha: .5)
                : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16.sp, color: AppColors.primaryBlue),
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: getTextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              date != null
                  ? DateFormat('MMM dd, yyyy').format(date)
                  : 'Select date',
              style: getTextStyle(
                fontSize: 15.sp,
                fontWeight: date != null ? FontWeight.w600 : FontWeight.normal,
                color: date != null
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.checkInDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // If check-out is before new check-in, reset check-out
      if (controller.checkOutDate.value != null &&
          controller.checkOutDate.value!.isBefore(picked)) {
        controller.setDates(picked, null);
      } else {
        controller.setDates(picked, controller.checkOutDate.value);
      }
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final checkIn = controller.checkInDate.value;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          controller.checkOutDate.value ??
          (checkIn ?? DateTime.now()).add(const Duration(days: 1)),
      firstDate: checkIn ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.setDates(controller.checkInDate.value, picked);
    }
  }
}
