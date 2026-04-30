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

  final isDashboardLoading = false.obs;
  final isRefreshing = false.obs;
  final errorMessage = ''.obs;

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
        fetchApartments(),
        fetchFurnishedApartments(),
      ]);
    } finally {
      isDashboardLoading.value = false;
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
      final data = await _dashboardService.fetchApartments();
      normalApartments.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
      normalApartments.value = [];
    }
  }

  Future<void> fetchFurnishedApartments() async {
    try {
      final data = await _dashboardService.fetchFurnishedApartments();
      furnishedApartments.value = data;
      AppLoggerHelper.debug(
        'Fetched ${furnishedApartments.length} furnished apartments',
      );
    } catch (e) {
      errorMessage.value = e.toString();
      furnishedApartments.value = [];
    }
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
