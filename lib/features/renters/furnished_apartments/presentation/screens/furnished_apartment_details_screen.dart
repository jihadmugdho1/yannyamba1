import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/utils/constants/app_texts.dart';
import 'package:yannyamba/features/renters/furnished_apartments/controllers/furnished_apartment_controller.dart';
import 'package:yannyamba/features/renters/home/presentation/widgets/widgets.dart'
    as home_widgets;
import '../widgets/furnished_price_section.dart';
import '../widgets/furnished_details_section.dart';

class FurnishedApartmentDetailsScreen extends StatelessWidget {
  final String apartmentId;

  FurnishedApartmentDetailsScreen({super.key, required this.apartmentId});

  final FurnishedApartmentController controller =
      Get.find<FurnishedApartmentController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final apartment = controller.apartments.firstWhereOrNull(
        (apt) => apt.id == apartmentId,
      );

      if (apartment == null) {
        return Scaffold(
          appBar: AppBar(title: Text(AppText.propertyNotFound.tr)),
          body: Center(child: Text(AppText.propertyNotFound.tr)),
        );
      }

      return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            home_widgets.HeaderImageAppBar(apartment: apartment),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FurnishedPriceSection(apartment: apartment),
                    SizedBox(height: 16.h),

                    // Calendar Booking System
                    //**************
                    //
                    // Integrate calendar booking system for furnished apartments
                    //
                    //**************** */
                    // CalendarBookingWidget(apartment: apartment),
                    // SizedBox(height: 20.h),

                    // home_widgets.ViewOnLocationButton(apartment: apartment),
                    // SizedBox(height: 20.h),
                    home_widgets.OwnerContact(apartment: apartment),
                    if (apartment.referenceContacts.isNotEmpty) ...{
                      SizedBox(height: 20.h),
                      home_widgets.ReferenceContacts(apartment: apartment),
                    },
                    SizedBox(height: 20.h),
                    home_widgets.AboutSection(apartment: apartment),
                    SizedBox(height: 20.h),
                    // Furnished-specific details
                    FurnishedDetailsSection(apartment: apartment),

                    SizedBox(height: 20.h),
                    home_widgets.BottomActions(apartment: apartment),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
