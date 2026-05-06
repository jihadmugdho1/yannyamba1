import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yannyamba/core/models/property/furnished_apartment_model.dart';
import 'package:yannyamba/core/utils/constants/app_texts.dart';
import 'package:yannyamba/features/owners/controllers/owner_navigation_controller.dart';
import 'package:yannyamba/features/owners/property/presentation/screeens/furnish_apartments_details.dart';
import 'package:yannyamba/features/owners/property/presentation/screeens/normal_apartments_details.dart';
import '../widgets/widgets.dart';
import '../widgets/filter_bottom_sheet.dart';
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
                    child: Column(
                      children: [
                        SectionHeader(
                          title: AppText.myProperties.tr,
                          actionText: AppText.addProperty.tr,
                          onActionTap: () {
                            Get.find<OwnerNavigationController>()
                                .goToAddProperty();
                          },
                          onFilterTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              builder: (_) =>
                                  FilterBottomSheet(controller: controller),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Obx(() {
                            if (controller.isDashboardLoading.value) {
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: 6,
                                itemBuilder: (context, index) {
                                  return const Padding(
                                    padding: EdgeInsets.only(bottom: 16),
                                    child: PropertyCardShimmer(),
                                  );
                                },
                              );
                            }

                            final all = controller.myselfProducts;

                            if (all.isEmpty) return _buildEmptyPropertyState();

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: all.length,
                              itemBuilder: (context, index) {
                                final item = all[index];

                                // FurnishedApartment has dailyRate, Apartment has rent
                                final isFurnished = item is FurnishedApartment;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: PropertyCard(
                                    productId: item.id,
                                    imageUrl: item.images.isNotEmpty
                                        ? item.images.first
                                        : 'assets/images/home_image.png',
                                    price: isFurnished
                                        ? '₣ ${(item).dailyRate}'
                                        : '₣ ${(item).rent}',
                                    isNormal: !isFurnished,
                                    views: item.totalViews ?? 0,
                                    inquiries: item.inquiries ?? 0,
                                    title: item.title,
                                    address:
                                        '${item.address.street}, ${item.address.city}',
                                    advancePayment:
                                        '${item.propertyDetails.advanceMonths} months',
                                    distance: item.distanceToDowntown == 0
                                        ? ''
                                        : '${item.distanceToDowntown} km away',
                                    onViewDetails: () {
                                      if (isFurnished) {
                                        Get.to(
                                          () => FurnishedApartmentDetails(
                                            apartmentId: item.id,
                                            apartment:
                                                item as FurnishedApartment,
                                          ),
                                        );
                                      } else {
                                        Get.to(
                                          () => NormalApartmentsDetails(
                                            apartmentId: item.id,
                                            apartment: item,
                                          ),
                                        );
                                      }
                                    },
                                    onDelete: () => _confirmDelete(
                                      context,
                                      controller,
                                      item.id,
                                    ),
                                    onShare: () {},
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ],
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
              productId: property.id,
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
              productId: property.id,
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

void _confirmDelete(
  BuildContext context,
  OwnerDashboardController controller,
  String productId,
) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Remove Property'),
      content: const Text(
        'Are you sure you want to remove this property? It will be hidden from listings.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(ctx).pop();
            final success = await controller.hideProperty(productId);
            if (!success) {
              Get.snackbar(
                'Error',
                'Failed to remove property. Please try again.',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: const Text('Remove', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
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
