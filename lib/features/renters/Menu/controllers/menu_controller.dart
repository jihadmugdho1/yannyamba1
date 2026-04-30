import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/controllers/navigation_controller.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/common/navigation/navigation_helper.dart';
import 'package:yannyamba/features/common/profile/controllers/profile_controller.dart';
import 'package:yannyamba/features/owners/dashboard/controllers/owner_dashboard_controller.dart';
import 'package:yannyamba/features/renters/authentication/controllers/authentication_controller.dart';
import 'package:yannyamba/features/renters/authentication/presentation/screens/login_screen.dart';
import 'package:yannyamba/features/renters/contact/presentation/screens/contact_screen.dart';
import 'package:yannyamba/features/renters/notification/presentation/screens/notification_screen.dart';

import '../presentation/screens/faq_page.dart';

class MenuScreenController extends GetxController {
  final NavigationController navigationController =
      Get.find<NavigationController>();
  final AuthenticationController authenticationController =
      Get.find<AuthenticationController>();

  final ProfileController profileController = Get.find<ProfileController>();
  final OwnerDashboardController ownerDashboardController =
      Get.find<OwnerDashboardController>();

  Future<void> handleSwitchToOwnersDashboard() async {
    final isLoggedIn = authenticationController.isLoggedIn.value;

    if (isLoggedIn) {
      ownerDashboardController.loadDashboard();
      await NavigationHelper.navigateToOwnerDashboard();
    } else {
      await StorageService.setRedirectToOwnersDashboard(true);
      Get.to(() => const AuthenticationLoginScreen());
    }
  }

  Future<void> handleLogout() async {
    // Show confirmation dialog
    final shouldLogout = await Get.dialog<bool>(
      AlertDialog(
        title: Text(AppText.logout.tr),
        content: Text(AppText.confirmLogout.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(Get.context!, false),
            child: Text(AppText.cancel.tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(Get.context!, true),
            child: Text(
              AppText.logout.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    // Navigate to home screen first (before clearing state)
    navigationController.changeTab(0);

    // Perform logout (this clears all storage and resets state)
    await authenticationController.logout();
  }

  void changeLanguage(String lang) {
    if (lang == 'EN') {
      Get.updateLocale(const Locale('en', 'US'));
    } else if (lang == 'FR') {
      Get.updateLocale(const Locale('fr', 'FR'));
    }
  }

  void navigateToProfile() {
    navigationController.changeTab(3);
  }

  void navigateToNotifications() {
    Get.to(() => const NotificationSettingsScreen());
  }

  void navigateToContact() {
    Get.to(() => const ContactScreen());
  }

  void navigateToFAQ() {
    Get.to(() => const FAQPage());
  }

  void handleLoginLogout() {
    final isLoggedIn = authenticationController.isLoggedIn.value;
    if (isLoggedIn) {
      handleLogout();
    } else {
      Get.to(() => const AuthenticationLoginScreen());
    }
  }

  bool shouldShowOwnerButton() {
    // final profile = profileController.profile.value;
    // return authenticationController.isLoggedIn.value &&
    //     (profile?.isOwner ?? false);
    return true;
  }
}
