import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/features/owners/profile/presentation/screens/owner_profile_screen.dart';
import 'controllers/owner_navigation_controller.dart';
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
        body: _getScreen(navigationController.currentIndex),
        bottomNavigationBar: OwnerBottomNavBar(
          currentIndex: navigationController.currentIndex,
          onTap: (index) {
            navigationController.changeIndex(index);
          },
        ),
      );
    });
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
