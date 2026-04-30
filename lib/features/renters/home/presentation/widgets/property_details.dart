import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

class PropertyDetails extends StatelessWidget {
  final Apartment apartment;

  const PropertyDetails({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final details = apartment.propertyDetails;
    final isOffice = apartment.type == 'Office';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppText.propertyDetails.tr,
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 16),

          // Rooms/Offices and Conference/Bathrooms row
          _twoColumnRow(
            isOffice ? AppText.officeRooms.tr : AppText.bedrooms.tr,
            '${apartment.rooms}',
            isOffice ? AppText.conferenceRooms.tr : AppText.bathrooms.tr,
            '${apartment.washrooms}',
          ),
          const SizedBox(height: 16),

          _twoColumnRow(
            AppText.propertyCategory.tr,
            apartment.propertyDetails.propertyType,
            AppText.squareFeet.tr,
            details.squareFeet > 0
                ? details.squareFeet.toStringAsFixed(0)
                : AppText.notSpecified.tr,
          ),
          const SizedBox(height: 16),
          _twoColumnRow(
            AppText.advancePaymentMonths.tr,
            '${details.advanceMonths}',
            AppText.depositMonths.tr,
            '${details.depositMonths}',
          ),
          const SizedBox(height: 16),
          _oneColumnRow(
            AppText.location.tr,
            '${apartment.address.street}, ${apartment.address.city}',
          ),
          if (details.distanceToDowntown > 0) ...[
            const SizedBox(height: 16),
            _oneColumnRow(
              AppText.distance.tr,
              '${details.distanceToDowntown} ${AppText.fromMainRoad.tr}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _twoColumnRow(
    String leftTitle,
    String leftValue,
    String rightTitle,
    String rightValue,
  ) {
    return Row(
      children: [
        Expanded(child: _infoColumn(leftTitle, leftValue)),
        Expanded(child: _infoColumn(rightTitle, rightValue)),
      ],
    );
  }

  Widget _oneColumnRow(String title, String value) {
    return Row(children: [Expanded(child: _infoColumn(title, value))]);
  }

  Widget _infoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getTextStyle(
            fontSize: 14,
            color: AppColors.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textColor2,
          ),
        ),
      ],
    );
  }
}
