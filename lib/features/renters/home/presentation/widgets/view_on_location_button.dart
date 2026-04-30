import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import 'package:yannyamba/features/renters/map/presentation/screens/apartment_map_screen.dart';

class ViewOnLocationButton extends StatelessWidget {
  final Apartment apartment;

  const ViewOnLocationButton({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Get.to(() => ApartmentMapScreen(apartment: apartment)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(ImagePath.locationIcon, height: 24.h, width: 24.w),
                const SizedBox(width: 8),
                Text(
                  'View Property On Map',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
