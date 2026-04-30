import 'package:get/get.dart';
import 'package:yannyamba/core/controllers/navigation_controller.dart';
import 'package:yannyamba/features/owners/controllers/owner_navigation_controller.dart';
import 'package:yannyamba/features/owners/owner_main_screen.dart';
import 'package:yannyamba/routes/app_routes.dart';

import '../../renters/authentication/data/services/authentication_service.dart';

/// Centralizes navigation transitions between renter and owner dashboards.
class NavigationHelper {
  const NavigationHelper._();

  /// Handles post-login routing after renter authentication completes.
  static Future<void> handlePostLoginNavigation({
    required AuthenticationService authenticationService,
  }) async {
    final shouldRedirectToOwners = await authenticationService
        .shouldRedirectToOwnersDashboard();

    if (shouldRedirectToOwners) {
      await authenticationService.clearRedirectToOwnersDashboard();
      await navigateToOwnerDashboard();
      return;
    }

    await navigateToRenterDashboard(tabIndex: 3);
  }

  /// Ensures the renter main screen is at the top of the navigator stack.
  static Future<void> _ensureOnMainScreen() async {
    if (Get.currentRoute == AppRoute.mainScreen) {
      return;
    }

    Get.until((route) {
      final isMain = route.settings.name == AppRoute.mainScreen;
      return isMain || route.isFirst;
    });

    if (Get.currentRoute != AppRoute.mainScreen) {
      await Get.offAllNamed(AppRoute.getMainScreen());
    }
  }

  /// Navigates into the owner dashboard, resetting its nav state.
  static Future<void> navigateToOwnerDashboard() async {
    await _ensureOnMainScreen();
    if (Get.isRegistered<OwnerNavigationController>()) {
      final ownerNavigationController = Get.find<OwnerNavigationController>();
      ownerNavigationController.goToDashboard();
    }
    await Get.to(() => const OwnerMainScreen());
  }

  /// Returns to the renter dashboard, selecting an optional tab index.
  static Future<void> navigateToRenterDashboard({int tabIndex = 0}) async {
    await _ensureOnMainScreen();
    if (Get.isRegistered<OwnerNavigationController>()) {
      final ownerNavigationController = Get.find<OwnerNavigationController>();
      ownerNavigationController.goToDashboard();
    }
    if (Get.isRegistered<NavigationController>()) {
      final navigationController = Get.find<NavigationController>();
      navigationController.changeTab(tabIndex);
    }
  }
}
