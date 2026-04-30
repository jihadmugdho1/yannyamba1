import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

class FurnishedDetailsSection extends StatelessWidget {
  final FurnishedApartment apartment;

  const FurnishedDetailsSection({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
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
            AppText.furnishedApartmentDetails.tr,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 16),

          // Check-in/Check-out Times
          _twoColumnRow(
            AppText.checkInTime.tr,
            apartment.checkInTime,
            AppText.checkOutTime.tr,
            apartment.checkOutTime,
          ),
          const SizedBox(height: 16),

          // Min/Max Stay
          _twoColumnRow(
            AppText.minimumStay.tr,
            '${apartment.minimumStay} ${AppText.night.tr}${apartment.minimumStay > 1 ? AppText.nights.tr : ''}',
            AppText.maximumStay.tr,
            '${apartment.maximumStay} ${AppText.nights.tr}',
          ),
          const SizedBox(height: 16),
          _singleRow(
            AppText.cancellationPolicy.tr,
            apartment.cancellationPolicy,
          ),

          // Furnishings
          if (apartment.furnishings.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              AppText.furnishingsIncluded.tr,
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: apartment.furnishings.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    item,
                    style: getTextStyle(
                      fontSize: 13,
                      color: AppColors.textColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          // House Rules
          if (apartment.houseRules.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              AppText.houseRules.tr,
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 12),
            ...apartment.houseRules.map((rule) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        rule,
                        style: getTextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _twoColumnRow(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: getTextStyle(fontSize: 13, color: AppColors.textColor2),
              ),
              const SizedBox(height: 4),
              Text(
                value1,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label2,
                style: getTextStyle(fontSize: 13, color: AppColors.textColor2),
              ),
              const SizedBox(height: 4),
              Text(
                value2,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _singleRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getTextStyle(fontSize: 13, color: AppColors.textColor2),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
            ),
          ),
        ),
      ],
    );
  }
}
