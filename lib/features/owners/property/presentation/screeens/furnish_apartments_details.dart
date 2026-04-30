import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import 'package:yannyamba/core/utils/constants/app_texts.dart';
import 'package:yannyamba/features/owners/dashboard/controllers/owner_dashboard_controller.dart';
import 'package:yannyamba/features/owners/property/presentation/widgets/owner_owner_contact_widget.dart';
import 'package:yannyamba/features/owners/property/presentation/widgets/owner_reference_widget.dart';
import 'package:yannyamba/features/renters/bookings/presentation/widgets/booking_dialog.dart';
import 'package:yannyamba/features/renters/furnished_apartments/presentation/widgets/furnished_details_section.dart';
import 'package:yannyamba/features/renters/home/presentation/widgets/widgets.dart'
    as home_widgets;

import '../../../../renters/furnished_apartments/presentation/widgets/furnished_price_section.dart';

class FurnishedApartmentDetails extends StatefulWidget {
  final String apartmentId;

  const FurnishedApartmentDetails({super.key, required this.apartmentId});

  @override
  State<FurnishedApartmentDetails> createState() =>
      _FurnishedApartmentDetailsState();
}

class _FurnishedApartmentDetailsState extends State<FurnishedApartmentDetails> {
  final OwnerDashboardController controller =
      Get.find<OwnerDashboardController>();

  late FurnishedApartment? _currentApartment;

  @override
  void initState() {
    super.initState();
    _updateCurrentApartment();
  }

  void _updateCurrentApartment() {
    _currentApartment = controller.furnishedApartments.firstWhereOrNull(
      (apt) => apt.id == widget.apartmentId,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Update apartment when controller changes
    _updateCurrentApartment();

    final apartment = _currentApartment;

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

                  // Owner Calendar Widget for Managing Availability
                  // OwnerCalendarWidget(
                  //   apartment: apartment,
                  //   onApartmentUpdated: _handleApartmentUpdate,
                  // ),
                  // SizedBox(height: 20.h),

                  // home_widgets.ViewOnLocationButton(apartment: apartment),
                  // SizedBox(height: 20.h),
                  OwnerOwnerContactWidget(apartment: apartment),
                  if (apartment.referenceContacts.isNotEmpty) ...{
                    SizedBox(height: 20.h),
                    OwnerReferenceWidget(apartment: apartment),
                  },
                  SizedBox(height: 20.h),
                  home_widgets.AboutSection(apartment: apartment),
                  SizedBox(height: 20.h),
                  // Furnished-specific details
                  FurnishedDetailsSection(apartment: apartment),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            child: ElevatedButton(
              onPressed: () => showBookingDialog(
                context: context,
                apartmentId: apartment.id,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
