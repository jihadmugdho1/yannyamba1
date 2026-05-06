import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/features/owners/profile/presentation/screens/owner_profile_screen.dart';
import 'controllers/owner_navigation_controller.dart';
import 'dashboard/controllers/owner_dashboard_controller.dart';
import 'bookings/controllers/owner_bookings_controller.dart';
import 'widgets/owner_bottom_nav_bar.dart';
import 'dashboard/presentation/screens/owners_dashboard_screen.dart';
import 'dashboard/presentation/screens/owner_properties_screen.dart';
import 'add_property/presentation/screens/add_property_screen.dart';

/// Main screen that manages navigation between different owner dashboard screens
class OwnerMainScreen extends StatelessWidget {
  const OwnerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the navigation controller
    final navigationController = Get.put(OwnerNavigationController());

    return Obx(() {
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () =>
              _refreshCurrentTab(navigationController.currentIndex),
          child: _getScreen(navigationController.currentIndex),
        ),
        bottomNavigationBar: OwnerBottomNavBar(
          currentIndex: navigationController.currentIndex,
          onTap: (index) {
            navigationController.changeIndex(index);
          },
        ),
      );
    });
  }

  Future<void> _refreshCurrentTab(int index) async {
    // Dashboard tab: refresh stats + properties + owner products
    if (index == 0 && Get.isRegistered<OwnerDashboardController>()) {
      await Get.find<OwnerDashboardController>().refreshDashboard();
      return;
    }

    // Properties tab: refresh owner listings + bookings
    if (index == 1) {
      if (Get.isRegistered<OwnerDashboardController>()) {
        await Get.find<OwnerDashboardController>().refreshMyProperties();
      }
      if (Get.isRegistered<OwnerBookingsController>()) {
        await Get.find<OwnerBookingsController>().refreshBookings();
      }
      return;
    }

    // Fallback: no-op for tabs without refresh.
    await Future<void>.value();
  }

  /// Get the screen widget based on the navigation index
  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const OwnersDashboardScreen();
      case 1:
        return const OwnerPropertiesScreen();
      case 2:
        return const AddPropertyScreen();
      case 3:
        return const OwnerProfileScreen();
      default:
        return const OwnersDashboardScreen();
    }
  }
}
