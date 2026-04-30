import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/renters/home/controllers/apartment_controller.dart';
import 'package:yannyamba/features/renters/home/presentation/widgets/apartment_card.dart';
import 'package:yannyamba/features/renters/home/presentation/screens/apartment_filter_screen.dart';
import 'package:yannyamba/features/renters/home/presentation/widgets/shimmer/shimmer_widgets.dart';

class NormalApartmentsScreen extends StatelessWidget {
  NormalApartmentsScreen({super.key});

  final ApartmentController controller = Get.find<ApartmentController>();
  final ScrollController scrollController = ScrollController();
  final List<String> categories = ["All", "Home", "Office"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppColors.primaryBlue,
        child: CustomScrollView(
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
                      AppText.normalApartments.tr,
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
                    onPressed: () async {
                      final result = await Get.to(
                        () => const ApartmentFilterScreen(),
                      );
                      if (result != null) {
                        controller.applyFilters(result as Map<String, dynamic>);
                      }
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
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      children: [
                        // Category Filters (static during loading)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: categories
                              .map((cat) => _buildCategoryButton(cat))
                              .toList(),
                        ),
                        SizedBox(height: 16.h),

                        // Shimmer Cards
                        ...List.generate(
                          3,
                          (index) => Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: const ApartmentCardShimmer(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      // Category Filters
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: categories
                            .map((cat) => _buildCategoryButton(cat))
                            .toList(),
                      ),
                      SizedBox(height: 16.h),

                      // Active Filters Chip
                      if (controller.hasActiveFilters)
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: _buildActiveFiltersChip(),
                        ),

                      // Empty State
                      if (controller.filteredApartments.isEmpty)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.w),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.home_outlined,
                                  size: 80,
                                  color: Colors.grey[300],
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  AppText.noApartmentsFound.tr,
                                  style: getTextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  AppText.tryAdjustingYourFilters.tr,
                                  style: getTextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                ElevatedButton(
                                  onPressed: () {
                                    controller.clearFilters();
                                    controller.changeCategory('All');
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
                        )
                      else
                        // Apartments List
                        ...controller.filteredApartments.map(
                          (apt) => Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: ApartmentCard(apartment: apt),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Handle pull-to-refresh action
  Future<void> _handleRefresh() async {
    await controller.refreshApartments();
  }

  Widget _buildCategoryButton(String label) {
    return Expanded(
      child: Obx(() {
        bool isSelected = controller.selectedType.value == label;
        return GestureDetector(
          onTap: () {
            controller.changeCategory(label);
            if (scrollController.hasClients) {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 24.h,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.typeColor : AppColors.textWhite,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: Center(
              child: Text(
                label == "All"
                    ? AppText.all.tr
                    : label == "Home"
                    ? AppText.home.tr
                    : AppText.office.tr,
                style: getTextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppColors.textWhite
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildActiveFiltersChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF3561FF).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFF3561FF).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.filter_list, size: 16.sp, color: const Color(0xFF3561FF)),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              AppText.activeFiltersApplied.tr,
              style: getTextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF3561FF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () {
              controller.clearFilters();
            },
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: const Color(0xFF3561FF).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 14.sp,
                color: const Color(0xFF3561FF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
