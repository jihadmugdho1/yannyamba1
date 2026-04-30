import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/features/common/stats/controllers/stats_controller.dart';
import 'package:yannyamba/features/renters/favorites/controllers/favorite_controller.dart';
import 'dart:io';

import '../../../../../core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import '../screens/view_details.dart';

// make sure this path is correct

class ApartmentCard extends StatelessWidget {
  final Apartment apartment;

  const ApartmentCard({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();
    final statsController = Get.find<StatsController>();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: .1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          Stack(
            children: [
              Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: _buildPropertyImage(),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Obx(() {
                  final isFavorite = favoriteController.isFavorite(
                    apartment.id,
                  );
                  return GestureDetector(
                    onTap: () => favoriteController.toggleFavorite(apartment),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isFavorite
                            ? AppColors.textWhite.withValues(alpha: .9)
                            : Colors.black.withValues(alpha: .3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? AppColors.error
                            : AppColors.textWhite,
                        size: 20,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  apartment.title,
                  style: getTextStyle(
                    color: AppColors.textColor,
                    fontSize: 16,
                    font: AppFont.montserrat,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  apartment.address.fullAddress,
                  style: getTextStyle(
                    color: AppColors.textColor2,
                    fontSize: 12,
                    font: AppFont.montserrat,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                Divider(color: Color(0xFFE5E5E5), thickness: 1),
                const SizedBox(height: 4),

                // Price Row
                Row(
                  children: [
                    Text(
                      '₣ ${apartment.rent.toStringAsFixed(0)}',
                      style: getTextStyle(
                        color: AppColors.textColor,
                        fontSize: 20,
                        font: AppFont.supreme,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      AppText.advance.tr,
                      style: getTextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,
                        font: AppFont.montserrat,
                      ),
                    ),
                    Text(
                      '${apartment.propertyDetails.advanceMonths} ${apartment.propertyDetails.advanceMonths == 1 ? AppText.month.tr : AppText.months.tr}',
                      style: getTextStyle(
                        color: AppColors.textColor,
                        fontSize: 14,
                        font: AppFont.montserrat,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                Divider(color: Color(0xFFE5E5E5), thickness: 1),
                const SizedBox(height: 4),

                // Property Details Row - Office or Home specific
                Row(
                  children: [
                    // First stat - Office Rooms or Bedrooms
                    Row(
                      children: [
                        Image.asset(ImagePath.roomIcon, width: 18, height: 18),
                        const SizedBox(width: 4),
                        Text(
                          apartment.type == 'Office'
                              ? '${apartment.rooms} ${AppText.officeRooms.tr}'
                              : '${apartment.rooms} ${AppText.rooms.tr}',
                          style: getTextStyle(
                            color: AppColors.textColor,
                            fontSize: 14,
                            font: AppFont.montserrat,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    // Second stat - Conference Rooms for Office, hidden for Home
                    const Spacer(),
                    if (apartment.type == 'Office') ...[
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          const Icon(
                            Icons.meeting_room,
                            size: 18,
                            color: Color(0xFF282828),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${apartment.washrooms} ${AppText.conf.tr}',
                            style: getTextStyle(
                              color: AppColors.textColor,
                              fontSize: 14,
                              font: AppFont.montserrat,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const Spacer(),

                    //Dont show size i f its office
                    // if (apartment.type == 'Home') ...[
                    //   const SizedBox(width: 16),
                    //   Row(
                    //     children: [
                    //       Image.asset(
                    //         ImagePath.sizeIcon,
                    //         width: 16,
                    //         height: 16,
                    //         color: Colors.black,
                    //       ),
                    //       const SizedBox(width: 4),
                    //       Text(
                    //         apartment.size > 0
                    //             ? '${apartment.size.toStringAsFixed(0)} ${AppText.sqmt.tr}'
                    //             : AppText.notSpecified.tr,
                    //         style: getTextStyle(
                    //           color: Colors.black,
                    //           font: AppFont.montserrat,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ],
                  ],
                ),
                const SizedBox(height: 8),

                Divider(color: Color(0xFFE5E5E5), thickness: 1),
                const SizedBox(height: 4),

                // Contact Owner Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => OwnerContactService.contactOwner(
                      context,
                      apartment,
                      apartment.owner!.name,
                      apartment.owner!.phone,
                    ),
                    icon: const Icon(Icons.contact_phone, size: 20),
                    label: Text(
                      AppText.contactOwner.tr,
                      style: getTextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        font: AppFont.montserrat,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      statsController.incrementViewCount(apartment.id);
                      Get.to(() => ViewDetails(apartmentId: apartment.id));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.typeColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppText.viewDetails.tr,
                      style: getTextStyle(
                        color: AppColors.textWhite,
                        fontSize: 14,
                        font: AppFont.montserrat,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyImage() {
    if (apartment.images.isEmpty) {
      // Default image when no images are available
      return Image.asset(
        ImagePath.homeImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    final imageUrl = apartment.images[0];

    // Check if it's a file path (uploaded image)
    if (imageUrl.startsWith('/') || imageUrl.contains('file://')) {
      return Image.file(
        File(imageUrl.replaceAll('file://', '')),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to default image if file doesn't exist
          return Image.asset(
            ImagePath.homeImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        },
      );
    }

    // Check if it's a network URL
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // Fallback to default image if network image fails (e.g., 556 error from Supabase)
          return Image.asset(
            ImagePath.homeImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        },
      );
    }

    // Otherwise, treat it as an asset
    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to default image if asset doesn't exist
        return Image.asset(
          ImagePath.homeImage,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      },
    );
  }
}
