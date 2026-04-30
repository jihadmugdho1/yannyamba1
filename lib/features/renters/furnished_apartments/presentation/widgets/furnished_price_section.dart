import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

class FurnishedPriceSection extends StatelessWidget {
  final FurnishedApartment apartment;

  const FurnishedPriceSection({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  apartment.title,
                  style: getTextStyle(
                    color: AppColors.textColor,
                    fontSize: 18,
                    font: AppFont.montserrat,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${apartment.address.street}, ${apartment.address.city}',
            style: getTextStyle(
              color: AppColors.textColor2,
              fontSize: 14,
              font: AppFont.montserrat,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          const Divider(color: Color(0xFFE5E5E5), thickness: 1),

          // Daily Rate Row
          Row(
            children: [
              Text(
                '₣ ${apartment.dailyRate.toStringAsFixed(0)}',
                style: getTextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 20,
                  font: AppFont.supreme,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppText.perNight.tr,
                style: getTextStyle(
                  color: AppColors.textColor2,
                  fontSize: 14,
                  font: AppFont.montserrat,
                ),
              ),
              const Spacer(),
              Text(
                '${AppText.min.tr} ${apartment.minimumStay} ${AppText.night.tr}${apartment.minimumStay > 1 ? AppText.nights.tr : ''}',
                style: getTextStyle(
                  color: AppColors.textColor2,
                  fontSize: 12,
                  font: AppFont.montserrat,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Divider(color: Color(0xFFE5E5E5), thickness: 1),
          const SizedBox(height: 4),

          // Property Stats Row
          Row(
            children: [
              Row(
                children: [
                  Text(
                    '${apartment.rooms}',
                    style: getTextStyle(
                      color: AppColors.textColor,
                      fontSize: 14,
                      font: AppFont.montserrat,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Image.asset(ImagePath.roomIcon, width: 18, height: 18),
                ],
              ),
              const SizedBox(width: 24),
              Row(
                children: [
                  Text(
                    '${apartment.washrooms}',
                    style: getTextStyle(
                      color: AppColors.textColor,
                      fontSize: 14,
                      font: AppFont.montserrat,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Image.asset(ImagePath.showerIcon, width: 18, height: 18),
                ],
              ),
              const Spacer(),
              // Row(
              //   children: [
              //     Image.asset(
              //       ImagePath.sizeIcon,
              //       width: 16,
              //       height: 16,
              //       color: Colors.black,
              //     ),
              //     const SizedBox(width: 4),
              //     Text(
              //       '${apartment.size.toStringAsFixed(0)} sqmt',
              //       style: getTextStyle(
              //         color: AppColors.textColor,
              //         fontSize: 14,
              //         font: AppFont.montserrat,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
