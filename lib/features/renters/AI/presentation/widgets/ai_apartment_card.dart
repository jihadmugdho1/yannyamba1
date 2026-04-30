import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/renters/AI/data/models/ai_apartment_model.dart';
import 'package:yannyamba/features/renters/furnished_apartments/presentation/screens/furnished_apartment_details_screen.dart';
import 'package:yannyamba/features/renters/home/presentation/screens/view_details.dart';

class AIApartmentCard extends StatelessWidget {
  final AIApartment apartment;

  const AIApartmentCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final isFurnished = apartment.listingType == 'Furnished Apartment';
    final displayPrice = isFurnished
        ? '\$${apartment.dailyRate?.toStringAsFixed(0) ?? 'N/A'}/day'
        : '\$${apartment.monthlyRent?.toStringAsFixed(0) ?? 'N/A'}/month';

    return GestureDetector(
      onTap: () {
        // Navigate to apartment details based on listing type
        if (isFurnished) {
          Get.to(
            () => FurnishedApartmentDetailsScreen(apartmentId: apartment.id),
          );
        } else {
          // Navigate to normal apartment details page
          Get.to(() => ViewDetails(apartmentId: apartment.id));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with type badge and price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isFurnished
                          ? AppColors.primaryBlue.withOpacity(0.1)
                          : AppColors.typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      apartment.listingType,
                      style: getTextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isFurnished
                            ? AppColors.primaryBlue
                            : AppColors.typeColor,
                      ),
                    ),
                  ),
                  Text(
                    displayPrice,
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Location
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: AppColors.textColor2,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      apartment.location,
                      style: getTextStyle(
                        fontSize: 13,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Bedrooms and Bathrooms
              Row(
                children: [
                  Icon(Icons.bed, size: 16, color: AppColors.textColor2),
                  const SizedBox(width: 4),
                  Text(
                    '${apartment.bedrooms} Bed${apartment.bedrooms > 1 ? 's' : ''}',
                    style: getTextStyle(
                      fontSize: 12,
                      color: AppColors.textColor2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.bathtub, size: 16, color: AppColors.textColor2),
                  const SizedBox(width: 4),
                  Text(
                    '${apartment.bathrooms} Bath${apartment.bathrooms > 1 ? 's' : ''}',
                    style: getTextStyle(
                      fontSize: 12,
                      color: AppColors.textColor2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // About preview
              Text(
                apartment.about.length > 80
                    ? '${apartment.about.substring(0, 80)}...'
                    : apartment.about,
                style: getTextStyle(fontSize: 11, color: AppColors.textColor2),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // View Details Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    if (isFurnished) {
                      Get.to(
                        () => FurnishedApartmentDetailsScreen(
                          apartmentId: apartment.id,
                        ),
                      );
                    } else {
                      // Navigate to normal apartment details page
                      Get.to(() => ViewDetails(apartmentId: apartment.id));
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View Details',
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 10,
                        color: AppColors.primaryBlue,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
