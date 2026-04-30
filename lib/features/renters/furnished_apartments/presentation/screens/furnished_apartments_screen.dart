import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/renters/furnished_apartments/controllers/furnished_apartment_controller.dart';
import 'package:yannyamba/features/renters/furnished_apartments/presentation/screens/furnished_apartment_details_screen.dart';
import 'package:yannyamba/features/renters/furnished_apartments/presentation/screens/furnished_apartment_filter_screen.dart';
import 'package:yannyamba/features/renters/furnished_apartments/presentation/widgets/furnished_apartment_card.dart';

class FurnishedApartmentsScreen extends StatelessWidget {
  FurnishedApartmentsScreen({super.key});

  final FurnishedApartmentController controller =
      Get.find<FurnishedApartmentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryBlue,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    AppText.furnishedApartments.tr,
                    style: getTextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: () {
                    Get.to(() => FurnishedApartmentFilterScreen());
                  },
                ),
              ],
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF3561FF), Color(0xFF5B7FFF)],
                ),
              ),
            ),
          ),
          // Loading State
          Obx(() {
            if (controller.isLoading.value) {
              return SliverFillRemaining(
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            // Empty State
            if (controller.filteredApartments.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        AppText.noFurnishedApartmentsFound.tr,
                        style: getTextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        AppText.tryAdjustingYourFilters.tr,
                        style: getTextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton(
                        onPressed: () {
                          controller.resetFilters();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32.w,
                            vertical: 12.h,
                          ),
                        ),
                        child: Text(
                          AppText.resetFilters.tr,
                          style: getTextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Apartments List
            return SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final apartment = controller.filteredApartments[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: FurnishedApartmentCard(
                      apartment: apartment,
                      onTap: () {
                        Get.to(
                          () => FurnishedApartmentDetailsScreen(
                            apartmentId: apartment.id,
                          ),
                        );
                      },
                    ),
                  );
                }, childCount: controller.filteredApartments.length),
              ),
            );
          }),
        ],
      ),
    );
  }
}
