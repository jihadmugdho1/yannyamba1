import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yannyamba/core/utils/constants/app_texts.dart';
import 'package:yannyamba/features/owners/bookings/controllers/owner_bookings_controller.dart';
import 'package:yannyamba/features/owners/bookings/presentation/screens/owner_booking_details_screen.dart';
import 'package:yannyamba/features/owners/bookings/presentation/widgets/owner_booking_card.dart';
import '../../../controllers/owner_navigation_controller.dart';
import '../widgets/widgets.dart';
import '../../../widgets/widgets.dart';
import '../../controllers/owner_dashboard_controller.dart';
import 'package:yannyamba/features/owners/property/presentation/screeens/furnish_apartments_details.dart';
import 'package:yannyamba/features/owners/property/presentation/screeens/normal_apartments_details.dart';

class OwnerPropertiesScreen extends StatefulWidget {
  const OwnerPropertiesScreen({super.key});

  @override
  State<OwnerPropertiesScreen> createState() => _OwnerPropertiesScreenState();
}

class _OwnerPropertiesScreenState extends State<OwnerPropertiesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final OwnerDashboardController _dashboardController;
  late final OwnerBookingsController _bookingsController;

  @override
  void initState() {
    super.initState();
    _dashboardController = Get.find<OwnerDashboardController>();
    _bookingsController = Get.find<OwnerBookingsController>();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      if (_tabController.index == 2) {
        _bookingsController.refreshBookings();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dashboardController.refreshDashboard();
      _bookingsController.refreshBookings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(text: "Furnished Apartments"),
                      Tab(text: "Normal Apartments"),
                      Tab(text: "My Bookings"),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildFurnishedApartmentsList(_dashboardController),
                      _buildNormalApartmentsList(_dashboardController),
                      _buildMyBookingsList(_bookingsController),
                    ],
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
      final isLoading = controller.isDashboardLoading.value;
      final list = controller.normalApartments;
      return RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        child: Builder(
          builder: (context) {
            if (isLoading) {
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

            // list is already captured above
            if (list.isEmpty) {
              return ListView(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [SizedBox(height: 400, child: _emptyState())],
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
                    address:
                        '${property.address.street}, ${property.address.city}',
                    advancePayment:
                        '${property.propertyDetails.advanceMonths} months',
                    distance: '${property.distanceToDowntown} km away',
                    onViewDetails: () {
                      Get.to(
                        () => NormalApartmentsDetails(
                          apartmentId: property.id,
                        ),
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
          },
        ),
      );
    });
  }

  Widget _buildFurnishedApartmentsList(OwnerDashboardController controller) {
    return Obx(() {
      final isLoading = controller.isDashboardLoading.value;
      final list = controller.furnishedApartments;
      return RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        child: Builder(
          builder: (context) {
            if (isLoading) {
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

            // list is already captured above
            if (list.isEmpty) {
              return ListView(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [SizedBox(height: 400, child: _emptyState())],
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
                    address:
                        '${property.address.street}, ${property.address.city}',
                    advancePayment:
                        '${property.propertyDetails.advanceMonths} months',
                    distance: '${property.distanceToDowntown} km away',
                    onViewDetails: () {
                      Get.to(
                        () => FurnishedApartmentDetails(
                          apartmentId: property.id,
                        ),
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
          },
        ),
      );
    });
  }

  Widget _buildMyBookingsList(OwnerBookingsController bookingsController) {
    return Obx(() {
      final isLoading = bookingsController.isLoading.value;
      final errorMessage = bookingsController.errorMessage.value;
      final list = bookingsController.bookings;
      return RefreshIndicator(
        onRefresh: bookingsController.refreshBookings,
        child: Builder(
          builder: (context) {
            if (isLoading) {
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

            if (errorMessage.isNotEmpty) {
              return ListView(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 400,
                    child: _errorState(
                      errorMessage,
                      bookingsController.refreshBookings,
                    ),
                  ),
                ],
              );
            }

            // list is already captured above
            if (list.isEmpty) {
              return ListView(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [SizedBox(height: 400, child: _emptyBookingsState())],
              );
            }

            return ListView.builder(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final booking = list[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: OwnerBookingCard(
                    booking: booking,
                    onViewDetails: () {
                      Get.to(
                        () => OwnerBookingDetailsScreen(
                          apartmentId: booking.apartmentId,
                          bookingId: booking.id,
                          apartment: booking.apartment,
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      );
    });
  }

  Widget _emptyBookingsState() {
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
            Icon(Iconsax.ticket, size: 48, color: Color(0xFFE5E7EB)),
            SizedBox(height: 16),
            Text(
              "No bookings yet",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF282828),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Pull down to refresh.",
              style: TextStyle(color: Color(0xFF686868)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorState(String message, Future<void> Function() onRetry) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Iconsax.warning_2, size: 42, color: Color(0xFFEF4444)),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF282828),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              onPressed: () => onRetry(),
              icon: const Icon(Iconsax.refresh, size: 18),
              label: Text(AppText.retry.tr),
            ),
          ],
        ),
      ),
    );
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
