import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/apartment_controller.dart';
import '../widgets/widgets.dart';

class ViewDetails extends StatelessWidget {
  final String apartmentId;

  const ViewDetails({super.key, required this.apartmentId});

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
                    OwnerContact(apartment: apartment),
                    if (apartment.referenceContacts.isNotEmpty) ...{
                      SizedBox(height: 20.h),
                      ReferenceContacts(apartment: apartment),
                    },
                    SizedBox(height: 20.h),
                    AboutSection(apartment: apartment),
                    SizedBox(height: 20.h),
                    PropertyDetails(apartment: apartment),
                    SizedBox(height: 20.h),
                    FeaturesAmenities(apartment: apartment),
                    SizedBox(height: 20.h),
                    BottomActions(apartment: apartment),
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
