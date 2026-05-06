import 'package:get/get.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import 'package:yannyamba/core/utils/logging/logger.dart';
import 'package:yannyamba/features/owners/dashboard/data/models/dashboard_stats_model.dart';
import 'package:yannyamba/features/owners/dashboard/data/models/owner_property_model.dart';
import 'package:yannyamba/features/owners/dashboard/data/services/owner_dashboard_service.dart';

class OwnerDashboardController extends GetxController {
  final OwnerDashboardService _dashboardService;

  OwnerDashboardController({required OwnerDashboardService dashboardService})
    : _dashboardService = dashboardService;

  final dashboardStats = Rxn<DashboardStats>();
  final properties = <OwnerProperty>[].obs;
  final normalApartments = <Apartment>[].obs;
  final furnishedApartments = <FurnishedApartment>[].obs;
  final allProducts = <Apartment>[].obs;
  final myselfProducts = <Apartment>[].obs;
  final homeProducts = <Apartment>[].obs;
  final officeProducts = <Apartment>[].obs;

  final isDashboardLoading = false.obs;
  final isRefreshing = false.obs;
  final errorMessage = ''.obs;

  // Filter state
  final selectedCategory = RxnString();
  final selectedCity = RxnString();
  final minBedrooms = Rxn<int>();
  final minBathrooms = Rxn<int>();
  final minPrice = RxnDouble();
  final maxPrice = RxnDouble();
  final rentalFilter = RxnString();
  final advancePayment = RxnString();
  final securityDeposit = RxnString();
  final neighborhood = RxnString();
  final page = RxnInt();
  final limit = RxnInt();

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      isDashboardLoading.value = true;
      await Future.wait([
        fetchDashboardStats(),
        fetchProperties(),
        fetchMyProducts(),
      ]);
    } finally {
      isDashboardLoading.value = false;
    }
  }

  Future<void> fetchMyProducts() async {
    try {
      final data = await _dashboardService.fetchMyselfProducts();
      myselfProducts.value = data;
      AppLoggerHelper.debug('Fetched ${myselfProducts.length} own products');
    } catch (e) {
      errorMessage.value = e.toString();
      myselfProducts.value = [];
    }
  }

  Future<bool> hideProperty(String productId) async {
    try {
      final success = await _dashboardService.hideApartment(productId);
      if (success) {
        myselfProducts.removeWhere((p) => p.id == productId);
      }
      return success;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }

  Future<void> fetchAllProducts() async {
    try {
      final data = await _dashboardService.fetchAllProducts(
        type: selectedCategory.value,
        rentalFilter: rentalFilter.value,
        minRent: minPrice.value,
        maxRent: maxPrice.value,
        bedrooms: minBedrooms.value,
        bathrooms: minBathrooms.value,
        advancePayment: advancePayment.value,
        securityDeposit: securityDeposit.value,
        city: selectedCity.value,
        neighborhood: neighborhood.value,
        page: page.value,
        limit: limit.value,
      );

      allProducts.value = data;
      AppLoggerHelper.debug('Fetched ${allProducts.length} total products');
    } catch (e) {
      errorMessage.value = e.toString();
      allProducts.value = [];
    }
  }

  Future<void> refreshMyProperties() async {
    isDashboardLoading.value = true;
    try {
      await Future.wait([fetchHomeProducts(), fetchOfficeProducts()]);
    } finally {
      isDashboardLoading.value = false;
    }
  }

  Future<void> fetchHomeProducts() async {
    try {
      final data = await _dashboardService.fetchMyselfProducts(
        propertyCategory: 'Home',
      );
      homeProducts.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
      homeProducts.value = [];
    }
  }

  Future<void> fetchOfficeProducts() async {
    try {
      final data = await _dashboardService.fetchMyselfProducts(
        propertyCategory: 'Office',
      );
      officeProducts.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
      officeProducts.value = [];
    }
  }

  Future<void> fetchDashboardStats() async {
    try {
      final stats = await _dashboardService.fetchDashboardStats();
      dashboardStats.value = stats;
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> fetchProperties() async {
    try {
      final data = await _dashboardService.fetchOwnerProperties();
      properties.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
      properties.value = [];
    }
  }

  Future<void> fetchApartments() async {
    try {
      final data = await _dashboardService.fetchApartments(
        type: selectedCategory.value,
        rentalFilter: rentalFilter.value,
        minRent: minPrice.value,
        maxRent: maxPrice.value,
        bedrooms: minBedrooms.value,
        bathrooms: minBathrooms.value,
        advancePayment: advancePayment.value,
        securityDeposit: securityDeposit.value,
        city: selectedCity.value,
        neighborhood: neighborhood.value,
        page: page.value,
        limit: limit.value,
      );
      normalApartments.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
      normalApartments.value = [];
    }
  }

  Future<void> fetchFurnishedApartments() async {
    try {
      final data = await _dashboardService.fetchFurnishedApartments(
        type: selectedCategory.value,
        rentalFilter: rentalFilter.value,
        minRent: minPrice.value,
        maxRent: maxPrice.value,
        bedrooms: minBedrooms.value,
        bathrooms: minBathrooms.value,
        advancePayment: advancePayment.value,
        securityDeposit: securityDeposit.value,
        city: selectedCity.value,
        neighborhood: neighborhood.value,
        page: page.value,
        limit: limit.value,
      );
      furnishedApartments.value = data;
      AppLoggerHelper.debug(
        'Fetched ${furnishedApartments.length} furnished apartments',
      );
    } catch (e) {
      errorMessage.value = e.toString();
      furnishedApartments.value = [];
    }
  }

  /// Apply filters and refresh lists
  Future<void> applyFilters({
    String? category,
    String? city,
    int? minBedrooms,
    int? minBathrooms,
    double? minPrice,
    double? maxPrice,
    String? rentalFilter,
    String? advancePayment,
    String? securityDeposit,
    String? neighborhood,
    int? page,
    int? limit,
  }) async {
    AppLoggerHelper.debug(
      'Applying filters: category=$category, city=$city, minBedrooms=$minBedrooms, rentalFilter=$rentalFilter',
    );

    selectedCategory.value = category;
    selectedCity.value = city;
    this.minBedrooms.value = minBedrooms;
    this.minBathrooms.value = minBathrooms;
    this.minPrice.value = minPrice;
    this.maxPrice.value = maxPrice;
    this.rentalFilter.value = rentalFilter;
    this.advancePayment.value = advancePayment;
    this.securityDeposit.value = securityDeposit;
    this.neighborhood.value = neighborhood;
    this.page.value = page;
    this.limit.value = limit;

    isDashboardLoading.value = true;
    try {
      await fetchAllProducts();
      AppLoggerHelper.debug(
        'Filters applied successfully. Total: ${allProducts.length}',
      );
    } catch (e) {
      AppLoggerHelper.error('Error applying filters', e);
    } finally {
      isDashboardLoading.value = false;
    }
  }

  void clearFilters() {
    AppLoggerHelper.debug('Clearing all filters');
    selectedCategory.value = null;
    selectedCity.value = null;
    minBedrooms.value = null;
    minBathrooms.value = null;
    minPrice.value = null;
    maxPrice.value = null;
    rentalFilter.value = null;
    advancePayment.value = null;
    securityDeposit.value = null;
    neighborhood.value = null;
    page.value = null;
    limit.value = null;
    // reload lists without filters
    loadDashboard();
  }

  Future<OwnerProperty?> getPropertyById(String id) async {
    try {
      return await _dashboardService.getPropertyById(id);
    } catch (e) {
      errorMessage.value = e.toString();
      return null;
    }
  }

  Future<void> refreshDashboard() async {
    if (isRefreshing.value) return;
    isRefreshing.value = true;
    try {
      await loadDashboard();
    } finally {
      isRefreshing.value = false;
    }
  }
}
