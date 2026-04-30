import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yannyamba/core/utils/constants/app_texts.dart';
import '../../../controllers/owner_navigation_controller.dart';
import '../widgets/widgets.dart';
import '../../../widgets/widgets.dart';
import '../../controllers/owner_dashboard_controller.dart';
import 'package:yannyamba/features/owners/property/presentation/screeens/furnish_apartments_details.dart';
import 'package:yannyamba/features/owners/property/presentation/screeens/normal_apartments_details.dart';

class OwnerPropertiesScreen extends StatelessWidget {
  const OwnerPropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OwnerDashboardController>();
    return Column(
      children: [
        const OwnerAppBar(userName: 'James'),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: () {
              Get.find<OwnerNavigationController>().goToAddProperty();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2196F3).withValues(alpha: .3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.add_circle5, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    AppText.addNewProperty.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Supreme',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshDashboard();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    SectionHeader(
                      title: AppText.myProperties.tr,
                      actionText: '',
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFF5F5F5),
                      ),
                      child: const TabBar(
                        indicatorColor: Colors.black,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: "Furnished Apartments"),
                          Tab(text: "Normal Apartments"),
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
        ),
      ],
    );
  }

  Widget _buildNormalApartmentsList(OwnerDashboardController controller) {
    return Obx(() {
      if (controller.isDashboardLoading.value) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
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
      if (list.isEmpty) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(height: 400, child: _emptyState()),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
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
              distance: '${property.distanceToDowntown} km away',
              onViewDetails: () {
                Get.to(() => NormalApartmentsDetails(apartmentId: property.id));
              },
              onDelete: () {
                _showDeleteDialog(property.id, property.title, controller);
              },
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
          physics: const AlwaysScrollableScrollPhysics(),
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
      if (list.isEmpty) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(height: 400, child: _emptyState()),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
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
              distance: '${property.distanceToDowntown} km away',
              onViewDetails: () {
                Get.to(
                  () => FurnishedApartmentDetails(apartmentId: property.id),
                );
              },
              onDelete: () {
                _showDeleteDialog(property.id, property.title, controller);
              },
              onShare: () {},
            ),
          );
        },
      );
    });
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Center(
        child: Column(
          children: [
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

  void _showDeleteDialog(
    String propertyId,
    String propertyTitle,
    OwnerDashboardController controller,
  ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          AppText.deleteProperty.tr,
          style: const TextStyle(
            fontFamily: 'Supreme',
            fontWeight: FontWeight.w600,
            color: Color(0xFF282828),
          ),
        ),
        content: Text(
          '${AppText.areYouSureYouWantToDelete.tr} "$propertyTitle"? ${AppText.thisActionCannotBeUndone.tr}',
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: Color(0xFF686868),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              AppText.cancel.tr,
              style: const TextStyle(
                color: Color(0xFF686868),
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              Get.snackbar(
                AppText.deleted.tr,
                '$propertyTitle ${AppText.hasBeenDeleted.tr}',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
              );
              await controller.fetchProperties();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              AppText.delete.tr,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
