import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/utils/constants/app_texts.dart';
import '../../controllers/add_property_controller.dart';
import '../../controllers/features_amenities_controller.dart';
import 'steps/step0_listing_type.dart';
import 'steps/step1_basic_info.dart';
import 'steps/step2_pricing_terms.dart';
import 'steps/step3_location_details.dart';
import 'steps/step4_features_amenities.dart';
import 'steps/step5_property_photos.dart';
import 'steps/step6_owner_details.dart';

class AddPropertyScreen extends StatelessWidget {
  const AddPropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    final controller = Get.put(AddPropertyController());
    Get.put(FeaturesAmenitiesController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppText.addProperty.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF282828),
            fontFamily: 'Supreme',
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress Bar
          _buildProgressBar(controller),

          // Content Area
          Expanded(
            child: Obx(() {
              return _getStepWidget(controller.currentStep.value);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(AddPropertyController controller) {
    return Obx(() {
      final progress = (controller.currentStep.value + 1) / 7;

      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppText.step.tr} ${controller.currentStep.value + 1} ${AppText.of.tr} 7',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF282828),
                    fontFamily: 'Supreme',
                  ),
                ),
                Text(
                  _getStepTitle(
                    controller.currentStep.value,
                    controller.listingType.value,
                  ),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF686868),
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF2196F3),
                ),
                minHeight: 6,
              ),
            ),
          ],
        ),
      );
    });
  }

  String _getStepTitle(int step, String listingType) {
    switch (step) {
      case 0:
        return AppText.listingType.tr;
      case 1:
        return AppText.basicInformation.tr;
      case 2:
        return listingType == 'furnished'
            ? AppText.pricingAndBooking.tr
            : AppText.pricingAndTerms.tr;
      case 3:
        return AppText.locationDetails.tr;
      case 4:
        return listingType == 'furnished'
            ? AppText.amenitiesAndRules.tr
            : AppText.featuresAndAmenities.tr;
      case 5:
        return AppText.propertyPhotos.tr;
      case 6:
        return AppText.ownerDetails.tr;
      default:
        return '';
    }
  }

  Widget _getStepWidget(int step) {
    switch (step) {
      case 0:
        return const Step0ListingType();
      case 1:
        return const Step1BasicInfo();
      case 2:
        return const Step2PricingTerms();
      case 3:
        return const Step3LocationDetails();
      case 4:
        return const Step4FeaturesAmenities();
      case 5:
        return const Step5PropertyPhotos();
      case 6:
        return const Step6OwnerDetails();
      default:
        return const Step0ListingType();
    }
  }
}
