import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yannyamba/core/core.dart';

class AmenitiesGrid extends StatelessWidget {
  final List<String> amenities;

  const AmenitiesGrid({super.key, required this.amenities});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: amenities.length,
      itemBuilder: (context, index) {
        final amenity = amenities[index];
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Icon(
                _getAmenityIcon(amenity),
                size: 18.sp,
                color: AppColors.primaryBlue,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  amenity,
                  style: getTextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getAmenityIcon(String amenity) {
    final lowerAmenity = amenity.toLowerCase();
    if (lowerAmenity.contains('wifi') || lowerAmenity.contains('internet')) {
      return Icons.wifi;
    } else if (lowerAmenity.contains('parking')) {
      return Icons.local_parking;
    } else if (lowerAmenity.contains('kitchen')) {
      return Icons.kitchen;
    } else if (lowerAmenity.contains('tv')) {
      return Icons.tv;
    } else if (lowerAmenity.contains('washer') ||
        lowerAmenity.contains('laundry')) {
      return Icons.local_laundry_service;
    } else if (lowerAmenity.contains('air') || lowerAmenity.contains('ac')) {
      return Icons.ac_unit;
    } else if (lowerAmenity.contains('pool')) {
      return Icons.pool;
    } else if (lowerAmenity.contains('gym')) {
      return Icons.fitness_center;
    } else if (lowerAmenity.contains('balcony') ||
        lowerAmenity.contains('patio')) {
      return Icons.balcony;
    } else if (lowerAmenity.contains('pet')) {
      return Icons.pets;
    } else if (lowerAmenity.contains('security')) {
      return Icons.security;
    } else if (lowerAmenity.contains('elevator')) {
      return Icons.elevator;
    } else if (lowerAmenity.contains('workspace') ||
        lowerAmenity.contains('office')) {
      return Icons.desk;
    } else if (lowerAmenity.contains('garden')) {
      return Icons.yard;
    } else {
      return Icons.check_circle_outline;
    }
  }
}
