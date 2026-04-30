import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/utils/constants/colors.dart';
import 'package:yannyamba/features/owners/property/presentation/widgets/owner_owner_contact_widget.dart';
import 'package:yannyamba/features/owners/property/presentation/widgets/owner_reference_widget.dart';
import 'package:yannyamba/features/renters/bookings/presentation/widgets/booking_dialog.dart';
import 'package:yannyamba/features/renters/home/controllers/apartment_controller.dart';

import '../../../../renters/home/presentation/widgets/widgets.dart';

class NormalApartmentsDetails extends StatelessWidget {
  final String apartmentId;

  const NormalApartmentsDetails({super.key, required this.apartmentId});

  @override
  Widget build(BuildContext context) {
    final ApartmentController controller = Get.find<ApartmentController>();

    return Obx(() {
      final apartment = controller.apartments.firstWhereOrNull(
        (apt) => apt.id == apartmentId,
      );

      if (apartment == null) {
        return Scaffold(
          appBar: AppBar(title: Text('Property Not Found')),
          body: Center(child: Text('Property not found')),
        );
      }

      return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            HeaderImageAppBar(apartment: apartment),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PriceAndAddress(apartment: apartment),
                    SizedBox(height: 16.h),
                    // ViewOnLocationButton(apartment: apartment),
                    // SizedBox(height: 20.h),
                    OwnerOwnerContactWidget(apartment: apartment),
                    if (apartment.referenceContacts.isNotEmpty) ...{
                      SizedBox(height: 20.h),
                      OwnerReferenceWidget(apartment: apartment),
                    },
                    SizedBox(height: 20.h),
                    AboutSection(apartment: apartment),
                    SizedBox(height: 20.h),
                    PropertyDetails(apartment: apartment),
                    SizedBox(height: 20.h),
                    FeaturesAmenities(apartment: apartment),
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
    });
  }
}
