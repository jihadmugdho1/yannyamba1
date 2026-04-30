import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yannyamba/core/utils/constants/app_texts.dart';
import 'package:yannyamba/features/owners/controllers/owner_navigation_controller.dart';
import 'package:yannyamba/features/owners/property/presentation/screeens/furnish_apartments_details.dart';
import 'package:yannyamba/features/owners/property/presentation/screeens/normal_apartments_details.dart';
import '../widgets/widgets.dart';
import '../../../widgets/widgets.dart';
import '../../controllers/owner_dashboard_controller.dart';

class OwnersDashboardScreen extends StatelessWidget {
  const OwnersDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerDashboardController>();

    return Column(
      children: [
        const OwnerAppBar(userName: 'James'),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshDashboard();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Obx(() {
                        if (controller.isDashboardLoading.value) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                StatCardShimmer(),
                                SizedBox(width: 8),
                                StatCardShimmer(),
                                SizedBox(width: 8),
                                StatCardShimmer(),
                              ],
                            ),
                          );
                        }

                        final stats = controller.dashboardStats.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              StatCard(
                                icon: Iconsax.eye4,
                                value: '${stats?.totalViews ?? 0}',
                                label: AppText.totalViews.tr,
                              ),
                              const SizedBox(width: 8),
                              StatCard(
                                icon: Iconsax.message_25,
                                value: '${stats?.inquiries ?? 0}',
                                label: AppText.inquiries.tr,
                              ),
                              const SizedBox(width: 8),
                              StatCard(
                                icon: Iconsax.verify5,
                                value: '${stats?.activeListings ?? 0}',
                                label: AppText.activeListings.tr,
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          SectionHeader(
                            title: AppText.myProperties.tr,
                            actionText: AppText.addProperty.tr,
                            onActionTap: () {
                              Get.find<OwnerNavigationController>()
                                  .goToAddProperty();
                            },
                          ),
                          const SizedBox(height: 12),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFF5F5F5),
                            ),
                            child: TabBar(
                              indicatorColor: Colors.black,
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey,
                              tabs: [
                                Tab(text: AppText.furnishedApartment.tr),
                                Tab(text: AppText.normalApartments.tr),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: TabBarView(
                              children: [
                                _buildFurnishedApartmentsList(controller),
                                _buildNormalApartmentsList(controller),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNormalApartmentsList(OwnerDashboardController controller) {
    return Obx(() {
      if (controller.isDashboardLoading.value) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: 3,
          itemBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: PropertyCardShimmer(isNormal: true),
            );
          },
        );
      }

      final list = controller.normalApartments;

      if (list.isEmpty) return _buildEmptyPropertyState();

      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final property = list[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PropertyCard(
              imageUrl: property.images.isNotEmpty
                  ? property.images.first
                  : 'assets/images/home_image.png',
              price: '₣ ${property.rent}',
              views: property.totalViews ?? 0,
              inquiries: property.inquiries ?? 0,
              title: property.title,
              address: '${property.address.street}, ${property.address.city}',
              advancePayment:
                  '${property.propertyDetails.advanceMonths} months',
              distance: property.distanceToDowntown == 0
                  ? ''
                  : '${property.distanceToDowntown} km away',
              onViewDetails: () {
                Get.to(() => NormalApartmentsDetails(apartmentId: property.id));
              },
              onDelete: () {},
              onShare: () {},
            ),
          );
        },
      );
    });
  }

  Widget _buildFurnishedApartmentsList(OwnerDashboardController controller) {
    return Obx(() {
      if (controller.isDashboardLoading.value) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: 3,
          itemBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: PropertyCardShimmer(isNormal: false),
            );
          },
        );
      }

      final list = controller.furnishedApartments;

      if (list.isEmpty) return _buildEmptyPropertyState();

      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final property = list[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PropertyCard(
              imageUrl: property.images.isNotEmpty
                  ? property.images.first
                  : 'assets/images/home_image.png',
              price: '₣ ${property.dailyRate}',
              isNormal: false,
              views: property.totalViews ?? 0,
              inquiries: property.inquiries ?? 0,
              title: property.title,
              address: '${property.address.street}, ${property.address.city}',
              advancePayment:
                  '${property.propertyDetails.advanceMonths} months',
              distance: property.distanceToDowntown == 0
                  ? ''
                  : '${property.distanceToDowntown} km away',
              onViewDetails: () {
                Get.to(
                  () => FurnishedApartmentDetails(apartmentId: property.id),
                );
              },
              onDelete: () {},
              onShare: () {},
            ),
          );
        },
      );
    });
  }
}

Widget _buildEmptyPropertyState() {
  return Container(
    padding: const EdgeInsets.all(32),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Color(0xFFE5E7EB)),
    ),
    child: Center(
      child: Column(
        children: const [
          Icon(Iconsax.home, size: 48, color: Color(0xFFE5E7EB)),
          SizedBox(height: 16),
          Text(
            "No properties yet",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF282828),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Start by adding your first property",
            style: TextStyle(color: Color(0xFF686868)),
          ),
        ],
      ),
    ),
  );
}
