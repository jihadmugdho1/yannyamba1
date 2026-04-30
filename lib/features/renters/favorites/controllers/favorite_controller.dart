import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/renters/authentication/controllers/authentication_controller.dart';
import 'package:yannyamba/features/renters/home/controllers/apartment_controller.dart';
import 'package:yannyamba/features/renters/furnished_apartments/controllers/furnished_apartment_controller.dart';
import 'package:yannyamba/features/renters/favorites/services/favorites_services.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

class FavoriteController extends GetxController {
  FavoriteController({
    required this.authenticationController,
    required this.apartmentController,
    required this.furnishedApartmentController,
    required this.favoritesService,
  });

  final AuthenticationController authenticationController;
  final ApartmentController apartmentController;
  final FurnishedApartmentController furnishedApartmentController;
  final FavoritesService favoritesService;

  final RxSet<String> _favoriteIds = <String>{}.obs;
  final RxList<Apartment> _favoriteApartments = <Apartment>[].obs;

  Set<String> get favoriteIds => _favoriteIds;

  bool get isLoggedIn => authenticationController.isLoggedIn.value;

  List<Apartment> get favoriteApartments => _favoriteApartments;

  bool isFavorite(String apartmentId) => _favoriteIds.contains(apartmentId);

  final RxBool isLoadingFavorites = false.obs;

  Future<void> loadFavorites() async {
    if (!authenticationController.isLoggedIn.value) {
      _favoriteIds.clear();
      _favoriteApartments.clear();
      return;
    }

    isLoadingFavorites.value = true;
    try {
      final favoriteApartments = await favoritesService.getFavorites();
      _favoriteApartments.clear();
      _favoriteApartments.addAll(favoriteApartments);
      _favoriteIds.clear();
      _favoriteIds.addAll(favoriteApartments.map((apt) => apt.id));
    } catch (e) {
      AppLoggerHelper.error('Error loading favorites', e);
      _showSnackbar(
        'Error',
        'Failed to load favorites. Please try again.',
        Colors.red.withValues(alpha: .8),
      );
    } finally {
      isLoadingFavorites.value = false;
    }
  }

  void toggleFavorite(Apartment apartment) async {
    if (!authenticationController.isLoggedIn.value) {
      _showSnackbar(
        'Sign in required',
        'Log in to save properties to your favorites list.',
        Colors.black.withValues(alpha: .8),
      );
      return;
    }

    final isCurrentlyFavorite = _favoriteIds.contains(apartment.id);

    try {
      if (isCurrentlyFavorite) {
        await favoritesService.removeFromFavorites(apartment.id);
        _favoriteIds.remove(apartment.id);
        _favoriteApartments.removeWhere((apt) => apt.id == apartment.id);

        _showSnackbar(
          'Removed from Favorites',
          '${apartment.title} has been removed from your favorites.',
          Colors.red.withValues(alpha: .8),
        );
      } else {
        await favoritesService.addToFavorites(apartment.id);
        _favoriteIds.add(apartment.id);
        _favoriteApartments.add(apartment);

        _showSnackbar(
          'Added to Favorites',
          '${apartment.title} has been added to your favorites.',
          Colors.green.withValues(alpha: .8),
        );
      }
    } catch (e) {
      _showSnackbar(
        'Error',
        'Failed to update favorite. Please try again.',
        Colors.red.withValues(alpha: .8),
      );
    }
  }

  void _showSnackbar(String title, String message, Color backgroundColor) {
    // Use a more robust approach with ScaffoldMessenger
    Future.delayed(const Duration(milliseconds: 100), () {
      final context = Get.context;
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            backgroundColor: backgroundColor,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    ever<bool>(authenticationController.isLoggedIn, (loggedIn) {
      if (loggedIn) {
        loadFavorites();
      } else {
        _favoriteIds.clear();
        _favoriteApartments.clear();
      }
    });

    // Load favorites if already logged in
    if (authenticationController.isLoggedIn.value) {
      loadFavorites();
    }
  }
}
