import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/features/common/stats/controllers/stats_controller.dart';
import 'package:yannyamba/features/renters/home/controllers/home_controller.dart';
import 'package:yannyamba/features/owners/add_property/controllers/city_selection_controller.dart';
// removed unused import: normal_apartments_coming_soon
import '../../../../../core/core.dart';
import '../../../furnished_apartments/controllers/furnished_apartment_controller.dart';
import '../../../furnished_apartments/presentation/widgets/furnished_apartment_card.dart';
import '../../../furnished_apartments/presentation/screens/furnished_apartment_filter_screen.dart';
import '../../../furnished_apartments/presentation/screens/furnished_apartment_details_screen.dart';
// removed unused import: normal_apartments_coming_soon
import '../widgets/shimmer/shimmer_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FurnishedApartmentController controller =
      Get.find<FurnishedApartmentController>();

  final HomeController homeController = Get.find<HomeController>();
  final StatsController statsController = Get.put(StatsController());

  // Focus node for the search field (so we can show city suggestions when focused)
  late final FocusNode searchFocusNode;
  // Controller for the city suggestions list scrolling
  late final ScrollController cityListScrollController;
  // Controller for the search text (used to show suggestions when text is present)
  late final TextEditingController searchController;
  // City selection controller provides the master list of cities
  final CitySelectionController citySelectionController =
      Get.find<CitySelectionController>();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // initialize search-related controllers and listeners so the UI rebuilds
    // when the search field focus or text changes
    searchFocusNode = FocusNode();
    cityListScrollController = ScrollController();
    searchController = TextEditingController();

    // Rebuild when focus changes or text changes to show/hide suggestions
    searchFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
    searchController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    // Dispose search-related controllers
    try {
      searchController.dispose();
    } catch (_) {}
    try {
      searchFocusNode.dispose();
    } catch (_) {}
    try {
      cityListScrollController.dispose();
    } catch (_) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showProfile: true,
        profileImageUrl: ImagePath.profileAvatar,
        title: AppText.goodMorning.tr,
        showBackButton: false,
        showSearch: true,
        showFilter: true,
        onSearchTap: _showCitySelectionBottomSheet,
        onFilterTap: () async {

          
          await Get.to(() => FurnishedApartmentFilterScreen());
        },
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerLoading();
        }

        return RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppColors.primaryBlue,
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              // City suggestions shown when the search field is focused or has text
              if (searchFocusNode.hasFocus || searchController.text.isNotEmpty)
                _buildCitySuggestions(),

              // Normal Apartments Featured Section (Card to navigate)
              // Obx(() {
              //   return homeController.showNotmalApartmentsSection.value
              //       ? const NormalApartmentsSection()
              //       : const ComingSoonCard();
              // }),

              // const SizedBox(height: 24),

              // Selected City Indicator
              Obx(() {
                if (controller.selectedSearchCity.value.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.primaryBlue.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.primaryBlue,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            controller.selectedSearchCity.value,
                            style: getTextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.clearCitySearch();
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              // Show furnished apartments list
              if (controller.filteredApartments.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppText.noFurnishedApartmentsFound.tr,
                          style: getTextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppText.tryAdjustingYourFilters.tr,
                          style: getTextStyle(
                            fontSize: 14,
                            color: AppColors.textColor2,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...controller.filteredApartments.map(
                  (apt) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: FurnishedApartmentCard(
                      apartment: apt,
                      onTap: () {
                        statsController.incrementViewCount(apt.id);
                        Get.to(
                          () => FurnishedApartmentDetailsScreen(
                            apartmentId: apt.id,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  /// Handle pull-to-refresh action
  Future<void> _handleRefresh() async {
    await controller.refreshApartments();
  }

  Widget _buildShimmerLoading() {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        // Normal Apartments Section Shimmer
        if (homeController.showNotmalApartmentsSection.value)
          const NormalApartmentsSectionShimmer(),
        const SizedBox(height: 24),

        // Furnished Apartments List Shimmer
        ...List.generate(
          3,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: FurnishedApartmentCardShimmer(),
          ),
        ),
      ],
    );
  }

  void _showCitySelectionBottomSheet() {
    final availableCities = controller.getAvailableCitiesFromApartments();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppText.selectCity.tr,
                      style: getTextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: AppColors.textColor2,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1.h, color: Colors.grey[200]),

            // Cities list
            Expanded(
              child: availableCities.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_off,
                              size: 64.sp,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              AppText.noCitiesAvailable.tr,
                              style: getTextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemCount: availableCities.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1.h,
                        indent: 20.w,
                        endIndent: 20.w,
                        color: Colors.grey[200],
                      ),
                      itemBuilder: (context, index) {
                        final city = availableCities[index];
                        final isSelected =
                            controller.selectedSearchCity.value == city;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              controller.selectCity(city);
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 16.h,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: isSelected
                                        ? AppColors.primaryBlue
                                        : AppColors.textColor2,
                                    size: 22.sp,
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: Text(
                                      city,
                                      style: getTextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: isSelected
                                            ? AppColors.primaryBlue
                                            : AppColors.textColor,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: AppColors.primaryBlue,
                                      size: 22.sp,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Small inline suggestions list shown under the search field when it's
  /// focused or there is search text. Uses apartments-derived available
  /// cities and filters them by the current searchController text.
  Widget _buildCitySuggestions() {
    final availableCities = controller.getAvailableCitiesFromApartments();
    final query = searchController.text.trim().toLowerCase();

    final suggestions = query.isEmpty
        ? availableCities.take(5).toList()
        : availableCities
              .where((c) => c.toLowerCase().contains(query))
              .toList();

    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        controller: cityListScrollController,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: suggestions.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: Colors.grey[200]),
        itemBuilder: (context, index) {
          final city = suggestions[index];

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                controller.selectCity(city);
                // clear and dismiss the search input
                searchController.clear();
                searchFocusNode.unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        city,
                        style: getTextStyle(
                          fontSize: 14,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // removed unused _buildNormalApartmentsSection to avoid unused_element lint
}
