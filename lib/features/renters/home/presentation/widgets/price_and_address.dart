import 'package:flutter/material.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

class PriceAndAddress extends StatelessWidget {
  final Apartment apartment;

  const PriceAndAddress({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            apartment.title,
            style: getTextStyle(
              color: AppColors.textColor,
              fontSize: 18,
              font: AppFont.montserrat,
              fontWeight: FontWeight.w600,
            ),
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
          Divider(color: Color(0xFFE5E5E5), thickness: 1),
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
                'Advance: ',
                style: getTextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                  font: AppFont.montserrat,
                ),
              ),
              Text(
                '${apartment.propertyDetails.advanceMonths} ${apartment.propertyDetails.advanceMonths == 1 ? "month" : "months"}',
                style: getTextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                  font: AppFont.montserrat,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Divider(color: Color(0xFFE5E5E5), thickness: 1),
          const SizedBox(height: 4),
          Row(
            children: [
              // First stat - Office Rooms or Bedrooms
              Row(
                children: [
                  Text(
                    apartment.type == 'Office'
                        ? '${apartment.rooms}'
                        : '${apartment.rooms}',
                    style: getTextStyle(
                      color: AppColors.textColor,
                      fontSize: 14,
                      font: AppFont.montserrat,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Image.asset(ImagePath.roomIcon, width: 18, height: 18),
                  const SizedBox(width: 4),
                  Text(
                    apartment.type == 'Office' ? 'Offices' : 'Rooms',
                    style: getTextStyle(
                      color: AppColors.textColor2,
                      fontSize: 12,
                      font: AppFont.montserrat,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),

              // Second stat - Conference Rooms or Bathrooms
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
                  apartment.type == 'Office'
                      ? const Icon(
                          Icons.meeting_room,
                          size: 18,
                          color: Color(0xFF282828),
                        )
                      : Image.asset(
                          ImagePath.showerIcon,
                          width: 18,
                          height: 18,
                        ),
                  const SizedBox(width: 4),
                  Text(
                    apartment.type == 'Office' ? 'Conf' : 'Baths',
                    style: getTextStyle(
                      color: AppColors.textColor2,
                      fontSize: 12,
                      font: AppFont.montserrat,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Image.asset(
                    ImagePath.sizeIcon,
                    width: 16,
                    height: 16,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    apartment.size > 0
                        ? '${apartment.size.toStringAsFixed(0)} sqmt'
                        : 'Not Specified',
                    style: getTextStyle(
                      color: Colors.black,
                      font: AppFont.montserrat,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (apartment.distanceToDowntown > 0)
            Text(
              '${apartment.distanceToDowntown} from main road',
              style: TextStyle(fontSize: 14, color: AppColors.textColor),
            ),
        ],
      ),
    );
  }
}
