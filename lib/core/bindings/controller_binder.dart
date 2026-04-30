import 'package:get/get.dart';
import 'package:yannyamba/features/renters/AI/controllers/chat_controller.dart';
import 'package:yannyamba/features/renters/authentication/controllers/authentication_controller.dart';
import 'package:yannyamba/features/renters/authentication/data/services/authentication_service.dart';
import 'package:yannyamba/features/renters/favorites/controllers/favorite_controller.dart';
import 'package:yannyamba/features/renters/favorites/services/favorites_services.dart';
import 'package:yannyamba/features/renters/home/controllers/home_controller.dart';
import 'package:yannyamba/features/renters/home/data/services/apartment_service.dart';
import 'package:yannyamba/features/common/profile/controllers/profile_controller.dart';
import 'package:yannyamba/features/common/profile/data/services/profile_service.dart';
import 'package:yannyamba/features/owners/dashboard/controllers/owner_dashboard_controller.dart';
import 'package:yannyamba/features/owners/dashboard/data/services/owner_dashboard_service.dart';
import 'package:yannyamba/features/owners/bookings/controllers/owner_bookings_controller.dart';
import 'package:yannyamba/features/owners/bookings/data/services/owner_bookings_service.dart';
import 'package:yannyamba/features/owners/add_property/controllers/add_property_controller.dart';
import 'package:yannyamba/features/owners/add_property/controllers/city_selection_controller.dart';
import 'package:yannyamba/features/owners/add_property/controllers/neighborhood_selection_controller.dart';
import 'package:yannyamba/features/owners/add_property/data/services/add_property_service.dart';
import 'package:yannyamba/features/owners/add_property/data/services/city_service.dart';
import 'package:yannyamba/features/owners/add_property/data/services/neighborhood_service.dart';
import 'package:yannyamba/features/renters/furnished_apartments/controllers/furnished_apartment_controller.dart';
import 'package:yannyamba/features/renters/furnished_apartments/data/services/furnished_apartment_service.dart';
import 'package:yannyamba/features/renters/bookings/controllers/booking_controller.dart';
import 'package:yannyamba/features/renters/bookings/controllers/my_bookings_controller.dart';
import 'package:yannyamba/features/renters/bookings/data/services/booking_service.dart';

import '../../features/renters/home/controllers/apartment_controller.dart';
import '../../features/renters/home/controllers/apartment_filter_controller.dart';
import '../../features/owners/controllers/owner_navigation_controller.dart';
import '../controllers/navigation_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<LogInController>(
    //       () => LogInController(),
    //   fenix: true,
    // );

    // Navigation Controllers
    Get.put(NavigationController());
    Get.put(OwnerNavigationController());
    Get.put(HomeController());

    // City Selection Controller (used by both owners and renters)
    Get.put(CityService());
    Get.put(
      CitySelectionController(cityService: Get.find<CityService>()),
      permanent: true,
    );
    Get.put(NeighborhoodService());
    Get.put(
      NeighborhoodSelectionController(
        neighborhoodService: Get.find<NeighborhoodService>(),
      ),
      permanent: true,
    );

    // Owner Services & Controllers
    Get.put(AddPropertyService());
    Get.lazyPut(() => AddPropertyController(), fenix: true);

    // Services
    Get.put(ApartmentService());
    Get.put(
      ApartmentController(apartmentService: Get.find<ApartmentService>()),
    );

    // Apartment Filter Controller
    Get.lazyPut(() => ApartmentFilterController(), fenix: true);

    // Furnished Apartments
    Get.put(FurnishedApartmentService());
    Get.put(
      FurnishedApartmentController(
        service: Get.find<FurnishedApartmentService>(),
      ),
    );

    Get.put(OwnerDashboardService());
    Get.put(
      OwnerDashboardController(
        dashboardService: Get.find<OwnerDashboardService>(),
      ),
    );

    Get.put(OwnerBookingsService());
    Get.put(OwnerBookingsController(service: Get.find<OwnerBookingsService>()));

    // Renters Booking
    Get.put(BookingService());
    Get.put(BookingController(service: Get.find<BookingService>()));
    Get.lazyPut(
      () => MyBookingsController(service: Get.find<BookingService>()),
      fenix: true,
    );
    Get.put(ChatController());
    Get.put(AuthenticationService());
    Get.put(FavoritesService());
    Get.put(
      AuthenticationController(
        authenticationService: Get.find<AuthenticationService>(),
      ),
      permanent: true,
    );
    Get.put(
      FavoriteController(
        authenticationController: Get.find<AuthenticationController>(),
        apartmentController: Get.find<ApartmentController>(),
        furnishedApartmentController: Get.find<FurnishedApartmentController>(),
        favoritesService: Get.find<FavoritesService>(),
      ),
      permanent: true,
    );
    Get.put(ProfileService());
    Get.lazyPut<ProfileController>(
      () => ProfileController(profileService: Get.find<ProfileService>()),
      fenix: true,
    );
  }
}
