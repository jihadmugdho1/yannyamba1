import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/common/widgets/custom_app_bar.dart';
import 'package:yannyamba/core/utils/constants/app_texts.dart';
import 'package:yannyamba/core/utils/constants/colors.dart';
import 'package:yannyamba/features/renters/favorites/controllers/favorite_controller.dart';
import 'package:yannyamba/features/renters/home/controllers/apartment_controller.dart';
import 'package:yannyamba/features/renters/home/presentation/widgets/apartment_card.dart';
import 'package:yannyamba/features/renters/furnished_apartments/presentation/widgets/furnished_apartment_card.dart';
import 'package:yannyamba/features/renters/furnished_apartments/presentation/screens/furnished_apartment_details_screen.dart';
import 'package:yannyamba/core/models/property/property_models.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();
    final apartmentController = Get.find<ApartmentController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: AppText.favoritesProperties.tr,
        showBackButton: false,
        centerTitle: true,
      ),
      body: Obx(() {
        if (!favoriteController.isLoggedIn) {
          return _EmptyState(
            title: AppText.signInToViewFavorites.tr,
            subtitle: AppText.logInToSavePropertiesAndAccessThemFromThisTab.tr,
          );
        }

        if (apartmentController.isLoading.value ||
            favoriteController.isLoadingFavorites.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final favoriteApartments = favoriteController.favoriteApartments;

        if (favoriteApartments.isEmpty) {
          return _EmptyState(
            title: AppText.yourFavoritePropertyListIsEmpty.tr,
            subtitle: AppText.tapTheHeartOnAnyListingToKeepItHandyHere.tr,
          );
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: favoriteApartments.length,
          itemBuilder: (context, index) {
            final apartment = favoriteApartments[index];
            // Check if it's a furnished apartment by checking the type
            if (apartment is FurnishedApartment) {
              return FurnishedApartmentCard(
                apartment: apartment,
                onTap: () {
                  Get.to(
                    () => FurnishedApartmentDetailsScreen(
                      apartmentId: apartment.id,
                    ),
                  );
                },
              );
            } else {
              return ApartmentCard(apartment: apartment);
            }
          },
          separatorBuilder: (_, __) => SizedBox(height: 16.h),
        );
      }),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black.withValues(alpha: .7),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black.withValues(alpha: .5),
              ),
            ),
            SizedBox(height: 24.h),
            const Icon(
              Icons.favorite_border,
              size: 48,
              color: AppColors.typeColor,
            ),
          ],
        ),
      ),
    );
  }
}
