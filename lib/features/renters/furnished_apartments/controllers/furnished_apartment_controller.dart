import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import 'package:yannyamba/features/owners/add_property/controllers/city_selection_controller.dart';
import '../data/services/furnished_apartment_service.dart';

/// Controller for managing furnished apartment data and state
class FurnishedApartmentController extends GetxController {
  final FurnishedApartmentService _service;

  FurnishedApartmentController({required FurnishedApartmentService service})
    : _service = service;

  static const int pageSize = 5;

  // Observable state
  final apartments = <FurnishedApartment>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Pagination state
  final _page = 1.obs;
  final _hasNextPage = true.obs;
  final isLoadingMore = false.obs;

  // Filtered apartments as observable
  final filteredApartments = <FurnishedApartment>[].obs;

  // Filter state
  final priceRange = RxList<double>([0, 1000]);
  final selectedGuests = 1.obs;
  final selectedRooms = 0.obs;
  final selectedBedrooms = 0.obs;
  final selectedBathrooms = 0.obs;
  final selectedAmenities = <String>[].obs;
  final minStay = 1.obs;
  final maxStay = 30.obs;

  // Date selection
  final checkInDate = Rx<DateTime?>(null);
  final checkOutDate = Rx<DateTime?>(null);

  // Neighborhood filter
  final selectedNeighborhoods = <String>[].obs;

  // City filter
  final selectedCities = <String>[].obs;

  // Search query for dynamic neighborhood search
  final searchQuery = ''.obs;

  // Selected city for search dropdown
  final selectedSearchCity = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFurnishedApartments(reset: true);
  }

  /// Fetch furnished apartments from service
  bool get canLoadMore =>
      _hasNextPage.value && !isLoading.value && !isLoadingMore.value;

  Future<void> fetchFurnishedApartments({required bool reset}) async {
    try {
      if (reset) {
        isLoading.value = true;
        errorMessage.value = '';
        _page.value = 1;
        _hasNextPage.value = true;
        apartments.clear();
        filteredApartments.clear();
      }

      final requestPage = _page.value;
      final requestLimit = pageSize;

      Map<String, dynamic>? responseMeta;
      final data = await _service.fetchFurnishedApartments(
        page: requestPage,
        limit: requestLimit,
        onMeta: (meta) => responseMeta = meta,
      );
      if (reset) {
        apartments.value = data;
      } else {
        apartments.addAll(data);
      }

      // Update price range to accommodate all apartments if no filter has been applied yet
      if (apartments.isNotEmpty &&
          priceRange[0] == 0 &&
          priceRange[1] == 1000) {
        final maxPrice = apartments
            .map((apt) => apt.dailyRate)
            .reduce((a, b) => a > b ? a : b);
        // Set range to show all apartments, with some buffer
        priceRange.value = [0, (maxPrice * 1.2).roundToDouble()];
        AppLoggerHelper.debug(
          'Updated price range to [0, ${priceRange[1]}] to show all apartments',
        );
      }

      // Update filtered apartments
      _updateFilteredApartments();

      final hasNext = _metaHasNextPage(
        meta: responseMeta,
        fallbackFetchedCount: data.length,
        limit: requestLimit,
      );
      _hasNextPage.value = hasNext;
      if (hasNext) _page.value = requestPage + 1;

      AppLoggerHelper.debug(
        'Fetched ${apartments.length} apartments, filtered: ${filteredApartments.length}',
      );
    } catch (e) {
      errorMessage.value =
          'Failed to load furnished apartments: ${e.toString()}';
      if (reset) {
        apartments.value = [];
        filteredApartments.value = [];
        _hasNextPage.value = false;
      }
    } finally {
      if (reset) isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!canLoadMore) return;
    isLoadingMore.value = true;
    try {
      await fetchFurnishedApartments(reset: false);
    } finally {
      isLoadingMore.value = false;
    }
  }

  bool _metaHasNextPage({
    required Map<String, dynamic>? meta,
    required int fallbackFetchedCount,
    required int limit,
  }) {
    if (meta == null) return fallbackFetchedCount >= limit;

    final hasNext = meta['hasNextPage'];
    if (hasNext is bool) return hasNext;
    if (hasNext is String) return hasNext.toLowerCase() == 'true';

    final currentPage = meta['page'];
    final totalPage = meta['totalPage'] ?? meta['total_page'];
    if (currentPage is int && totalPage is int) return currentPage < totalPage;

    final total = meta['total'];
    final skip = meta['skip'];
    final metaLimit = meta['limit'];
    if (total is int && skip is int && metaLimit is int) {
      return (skip + metaLimit) < total;
    }

    return fallbackFetchedCount >= limit;
  }

  /// Get filtered apartments based on criteria
  List<FurnishedApartment> _getFilteredApartments() {
    return apartments.where((apt) {
      // Price filter
      if (apt.dailyRate < priceRange[0] || apt.dailyRate > priceRange[1]) {
        return false;
      }

      // Room filter
      if (selectedRooms.value > 0 && apt.rooms < selectedRooms.value) {
        return false;
      }

      // Bathroom filter
      if (selectedBathrooms.value > 0 &&
          apt.washrooms < selectedBathrooms.value) {
        return false;
      }

      // Amenities filter
      if (selectedAmenities.isNotEmpty) {
        if (!selectedAmenities.every(
          (amenity) => apt.amenities.contains(amenity),
        )) {
          return false;
        }
      }

      // Date availability filter - only apply when both dates are selected
      if (checkInDate.value != null && checkOutDate.value != null) {
        final isAvailable = apt.isAvailable(
          checkInDate.value!,
          checkOutDate.value!,
        );

        if (!isAvailable) {
          AppLoggerHelper.debug(
            'Apartment ${apt.id} (${apt.title}) is not available for '
            '${checkInDate.value} to ${checkOutDate.value}. '
            'Has ${apt.bookings.length} bookings and ${apt.blockedDates.length} blocked dates.',
          );
        }

        return isAvailable;
      }

      // City filter
      if (selectedCities.isNotEmpty) {
        final apartmentCity = apt.address.city.toLowerCase().trim();
        bool matchesCity = false;

        for (var selectedCity in selectedCities) {
          final selectedCityLower = selectedCity.toLowerCase().trim();
          if (apartmentCity.contains(selectedCityLower) ||
              selectedCityLower.contains(apartmentCity)) {
            matchesCity = true;
            break;
          }
        }

        if (!matchesCity) {
          return false;
        }
      }

      // Neighborhood filter
      if (selectedNeighborhoods.isNotEmpty) {
        final apartmentCity = apt.address.city.toLowerCase().trim();
        final apartmentNeighborhood = apt.address.street.toLowerCase().trim();

        bool matchesFilter = false;

        for (var selectedNeighborhood in selectedNeighborhoods) {
          final selectedLower = selectedNeighborhood.toLowerCase().trim();

          if (apartmentNeighborhood.contains(selectedLower) ||
              apartmentCity.contains(selectedLower) ||
              selectedLower.contains(apartmentNeighborhood)) {
            matchesFilter = true;
            break;
          }

          if (matchesFilter) break;
        }

        if (!matchesFilter) {
          return false;
        }
      }

      // Dynamic search filter by neighborhood
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase().trim();
        final apartmentNeighborhood = apt.address.street.toLowerCase().trim();
        final apartmentCity = apt.address.city.toLowerCase().trim();

        // Check if search query matches neighborhood or city
        if (!apartmentNeighborhood.contains(query) &&
            !apartmentCity.contains(query)) {
          return false;
        }
      }

      // City search dropdown filter
      if (selectedSearchCity.value.isNotEmpty) {
        final apartmentCity = apt.address.city.toLowerCase().trim();
        final selectedCity = selectedSearchCity.value.toLowerCase().trim();

        if (!apartmentCity.contains(selectedCity) &&
            !selectedCity.contains(apartmentCity)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Update filtered apartments
  void _updateFilteredApartments() {
    filteredApartments.value = _getFilteredApartments();
  }

  /// Get sorted apartments (by price, rating, etc.)
  List<FurnishedApartment> getSortedApartments(String sortBy) {
    final filtered = filteredApartments;

    switch (sortBy) {
      case 'price_low':
        filtered.sort((a, b) => a.dailyRate.compareTo(b.dailyRate));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.dailyRate.compareTo(a.dailyRate));
        break;
      case 'rooms':
        filtered.sort((a, b) => b.rooms.compareTo(a.rooms));
        break;
      default:
        // Keep original order
        break;
    }

    return filtered;
  }

  /// Set date range
  void setDates(DateTime? checkIn, DateTime? checkOut) {
    checkInDate.value = checkIn;
    checkOutDate.value = checkOut;
    _updateFilteredApartments();
  }

  /// Calculate total nights
  int? get totalNights {
    if (checkInDate.value != null && checkOutDate.value != null) {
      return checkOutDate.value!.difference(checkInDate.value!).inDays;
    }
    return null;
  }

  /// Update price range filter
  void updatePriceRange(double min, double max) {
    priceRange.value = [min, max];
    _updateFilteredApartments();
  }

  /// Update room filter
  void updateRooms(int rooms) {
    selectedRooms.value = rooms;
    _updateFilteredApartments();
  }

  /// Update bathroom filter
  void updateBathrooms(int bathrooms) {
    selectedBathrooms.value = bathrooms;
    _updateFilteredApartments();
  }

  /// Toggle amenity filter
  void toggleAmenity(String amenity) {
    if (selectedAmenities.contains(amenity)) {
      selectedAmenities.remove(amenity);
    } else {
      selectedAmenities.add(amenity);
    }
    _updateFilteredApartments();
  }

  /// Update search query for dynamic neighborhood search
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    _updateFilteredApartments();
  }

  /// Clear search query
  void clearSearchQuery() {
    searchQuery.value = '';
    _updateFilteredApartments();
  }

  /// Toggle neighborhood filter
  void toggleNeighborhood(String neighborhood) {
    if (selectedNeighborhoods.contains(neighborhood)) {
      selectedNeighborhoods.remove(neighborhood);
    } else {
      selectedNeighborhoods.add(neighborhood);
    }
    _updateFilteredApartments();
  }

  /// Toggle city filter
  void toggleCity(String city) {
    if (selectedCities.contains(city)) {
      selectedCities.remove(city);
    } else {
      selectedCities.add(city);
    }
    _updateFilteredApartments();
  }

  /// Reset all filters
  void resetFilters() {
    // Reset to price range that shows all apartments
    final maxRange = apartmentsPriceRange;
    priceRange.value = [0, maxRange[1]];
    selectedGuests.value = 1;
    selectedRooms.value = 0;
    selectedBedrooms.value = 0;
    selectedBathrooms.value = 0;
    selectedAmenities.clear();
    selectedCities.clear();
    selectedNeighborhoods.clear();
    searchQuery.value = ''; // Clear search query
    selectedSearchCity.value = ''; // Clear city search
    checkInDate.value = null;
    checkOutDate.value = null;

    _updateFilteredApartments();
    AppLoggerHelper.debug('All filters have been reset');
  }

  /// Check if any filters are active
  bool get hasActiveFilters {
    // Check if price range is modified from default
    final defaultMaxPrice = apartmentsPriceRange[1];
    final isPriceFiltered =
        priceRange[0] != 0 || priceRange[1] != defaultMaxPrice;

    return isPriceFiltered ||
        selectedRooms.value > 0 ||
        selectedBathrooms.value > 0 ||
        selectedAmenities.isNotEmpty ||
        selectedCities.isNotEmpty ||
        selectedNeighborhoods.isNotEmpty ||
        checkInDate.value != null ||
        checkOutDate.value != null;
  }

  /// Get count of active filters
  int get activeFiltersCount {
    int count = 0;

    // Check price range
    final defaultMaxPrice = apartmentsPriceRange[1];
    if (priceRange[0] != 0 || priceRange[1] != defaultMaxPrice) count++;

    // Check rooms and bathrooms
    if (selectedRooms.value > 0) count++;
    if (selectedBathrooms.value > 0) count++;

    // Check amenities
    if (selectedAmenities.isNotEmpty) count++;

    // Check cities
    if (selectedCities.isNotEmpty) count++;

    // Check neighborhoods
    if (selectedNeighborhoods.isNotEmpty) count++;

    // Check dates
    if (checkInDate.value != null && checkOutDate.value != null) count++;

    return count;
  }

  /// Get apartment by ID
  Future<FurnishedApartment?> getApartmentById(String id) async {
    try {
      isLoading.value = true;
      return await _service.getFurnishedApartmentById(id);
    } catch (e) {
      errorMessage.value = 'Failed to load apartment: ${e.toString()}';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh apartments list
  Future<void> refreshApartments() async {
    await fetchFurnishedApartments(reset: true);
  }

  /// Get available amenities from all apartments
  List<String> get availableAmenities {
    final Set<String> amenities = {};
    for (var apt in apartments) {
      amenities.addAll(apt.amenities);
    }
    return amenities.toList()..sort();
  }

  /// Get price range from all apartments
  List<double> get apartmentsPriceRange {
    if (apartments.isEmpty) return [0, 1000];

    double min = apartments.first.dailyRate;
    double max = apartments.first.dailyRate;

    for (var apt in apartments) {
      if (apt.dailyRate < min) min = apt.dailyRate;
      if (apt.dailyRate > max) max = apt.dailyRate;
    }

    return [min, max];
  }

  /// Get available cities from all apartments
  List<String> get availableCities {
    final cityController = Get.find<CitySelectionController>();
    return cityController.cities;
  }

  /// Get available cities from apartments that actually have properties
  List<String> getAvailableCitiesFromApartments() {
    if (apartments.isEmpty) return [];

    final Set<String> cities = {};
    for (var apt in apartments) {
      if (apt.address.city.isNotEmpty) {
        cities.add(apt.address.city);
      }
    }

    final cityList = cities.toList()..sort();
    return cityList;
  }

  /// Select a city for search
  void selectCity(String city) {
    selectedSearchCity.value = city;
    _updateFilteredApartments();
  }

  /// Clear city search
  void clearCitySearch() {
    selectedSearchCity.value = '';
    _updateFilteredApartments();
  }

  /// Get available neighborhoods from all apartments
  List<String> get availableNeighborhoods {
    final neighborhoods = apartments
        .map((apt) => apt.address.street.trim())
        .where((street) => street.isNotEmpty)
        .toSet()
        .toList();

    neighborhoods.sort();
    return neighborhoods;
  }
}
