import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/common/widgets/custom_navbar.dart';
import 'package:yannyamba/core/controllers/navigation_controller.dart';
import 'package:yannyamba/core/services/deep_link_service.dart';
import 'package:yannyamba/features/renters/AI/presentation/screens/ai_onboarding_screen.dart';
import 'package:yannyamba/features/renters/Menu/presentation/screens/menu_screen.dart';
import 'package:yannyamba/features/renters/favorites/presentation/screens/favorite_screen.dart';
import 'package:yannyamba/features/renters/profile/presentation/screens/profile_screen.dart';

import 'features/renters/home/presentation/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final NavigationController navigationController =
      Get.find<NavigationController>();

  final List<Widget> _pages = [
    HomeScreen(),
    FavoritesScreen(),
    AiOnboardingScreen(),
    ProfileScreen(),
    SettingsMenu(),
  ];

  @override
  void initState() {
    super.initState();
    // Process any pending deep link after the screen is fully rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Wait for UI to be fully stable
      Future.delayed(const Duration(milliseconds: 2500), () {
        DeepLinkService().processPendingLink();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int currentIndex = navigationController.currentIndex.value;
      return Scaffold(
        body: _pages[currentIndex],
        bottomNavigationBar: CustomNavBar(
          currentIndex: currentIndex,
          onTap: navigationController.changeTab,
        ),
      );
    });
  }
}
