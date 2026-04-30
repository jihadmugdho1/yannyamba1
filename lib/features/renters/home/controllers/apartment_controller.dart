import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import 'package:yannyamba/features/renters/home/data/services/apartment_service.dart';

/// Controller for managing apartment data and state
class ApartmentController extends GetxController {
  final ApartmentService _apartmentService;

  ApartmentController({required ApartmentService apartmentService})
    : _apartmentService = apartmentService;

  // Observable state
  final apartments = <Apartment>[].obs;
  final isLoading = false.obs;
  final selectedType = 'All'.obs;
  final errorMessage = ''.obs;
  final Rx<Map<String, dynamic>?> activeFilters = Rx<Map<String, dynamic>?>(
    null,
  );

  @override
  void onInit() {
    super.onInit();
    fetchApartments();
  }

  /// Fetch apartments from service
  Future<void> fetchApartments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final data = await _apartmentService.fetchApartments();
      apartments.value = data;
    } catch (e) {
      errorMessage.value = 'Failed to load apartments: ${e.toString()}';
      apartments.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Get filtered apartments based on selected type and advanced filters
  List<Apartment> get filteredApartments {
    List<Apartment> filtered = apartments;

    // Apply category filter first
    if (selectedType.value != 'All') {
      filtered = filtered
          .where((apt) => apt.type == selectedType.value)
          .toList();
    }

    // Apply advanced filters if any
    if (activeFilters.value != null) {
      filtered = _applyAdvancedFilters(filtered, activeFilters.value!);
    }

    return filtered;
  }

  /// Apply advanced filters from filter screen
  List<Apartment> _applyAdvancedFilters(
    List<Apartment> apartments,
    Map<String, dynamic> filters,
  ) {
    return apartments.where((apt) {
      // Property Type Filter (matching categories: All, Home, Office)
      if (filters['propertyType'] != null && filters['propertyType'] != 'All') {
        final propertyType = filters['propertyType'] as String;
        final aptType = apt.type.trim();

        // Match property type case-insensitively
        if (aptType.toLowerCase() != propertyType.toLowerCase()) {
          return false;
        }
      }

      // Price Range Filter
      if (filters['priceRange'] != null) {
        final priceRange = filters['priceRange'] as Map<String, dynamic>;
        final minPrice = (priceRange['min'] as num).toDouble();
        final maxPrice = (priceRange['max'] as num).toDouble();

        // Only apply if price range is modified from default (0-5000)
        if (minPrice > 0 || maxPrice < 5000) {
          if (apt.rent < minPrice || apt.rent > maxPrice) {
            return false;
          }
        }
      }

      // Square Footage Filter
      if (filters['squareFootageRange'] != null) {
        final sizeRange = filters['squareFootageRange'] as Map<String, dynamic>;
        final minSize = (sizeRange['min'] as num).toDouble();
        final maxSize = (sizeRange['max'] as num).toDouble();

        // Only apply if size range is modified from default (500-5000)
        if (minSize > 500 || maxSize < 5000) {
          if (apt.size < minSize || apt.size > maxSize) {
            return false;
          }
        }
      }

      // City Filter
      if (filters['city'] != null && filters['city'] != 'All') {
        final selectedCity = filters['city'].toString().toLowerCase().trim();
        final aptCity = apt.address.city.toLowerCase().trim();
        final aptStreet = apt.address.street.toLowerCase().trim();

        // Match city name or neighborhood (street) name
        final cityMatches =
            aptCity.contains(selectedCity) ||
            selectedCity.contains(aptCity) ||
            aptStreet.contains(selectedCity) ||
            selectedCity.contains(aptStreet);

        if (!cityMatches) {
          return false;
        }
      }

      // Neighborhoods Filter (multiple selection)
      if (filters['neighborhoods'] != null) {
        final neighborhoods = filters['neighborhoods'] as List;
        if (neighborhoods.isNotEmpty) {
          final aptCity = apt.address.city.toLowerCase().trim();
          final aptStreet = apt.address.street.toLowerCase().trim();

          // Check if apartment matches any of the selected neighborhoods
          final matchesAnyNeighborhood = neighborhoods.any((neighborhood) {
            final n = neighborhood.toString().toLowerCase().trim();
            return aptCity.contains(n) ||
                n.contains(aptCity) ||
                aptStreet.contains(n) ||
                n.contains(aptStreet);
          });

          if (!matchesAnyNeighborhood) {
            return false;
          }
        }
      }

      // Bedrooms Filter (only for non-office properties)
      if (filters['bedrooms'] != null &&
          filters['propertyType'] != 'Office' &&
          apt.type.toLowerCase() != 'office') {
        final bedrooms = filters['bedrooms'] as String;

        if (bedrooms == 'Single Room' || bedrooms == 'Studio') {
          if (apt.rooms != 1) return false;
        } else if (bedrooms == 'Single Modern Room') {
          if (apt.rooms != 1) return false;
        } else if (bedrooms == '1 Bedroom') {
          if (apt.rooms != 1) return false;
        } else if (bedrooms == '2 Bedrooms') {
          if (apt.rooms != 2) return false;
        } else if (bedrooms.contains('3+')) {
          if (apt.rooms < 3) return false;
        }
      }

      // Bathrooms Filter (only for non-office properties)
      if (filters['bathrooms'] != null &&
          filters['propertyType'] != 'Office' &&
          apt.type.toLowerCase() != 'office') {
        final bathrooms = filters['bathrooms'] as String;

        if (bathrooms == '1' || bathrooms == 'One') {
          if (apt.washrooms != 1) return false;
        } else if (bathrooms == '2' || bathrooms == 'Two') {
          if (apt.washrooms != 2) return false;
        } else if (bathrooms == '3' || bathrooms == 'Three') {
          if (apt.washrooms != 3) return false;
        } else if (bathrooms.contains('4+') || bathrooms.contains('Four')) {
          if (apt.washrooms < 4) return false;
        }
      }

      // Lease Takeover Filter
      if (filters['leaseTransferOnly'] == true) {
        // Check if property has lease transfer available in features
        final hasLeaseOption = apt.features.any(
          (feature) =>
              feature.toLowerCase().contains('lease') ||
              feature.toLowerCase().contains('transfer') ||
              feature.toLowerCase().contains('takeover'),
        );
        if (!hasLeaseOption) return false;
      }

      // Distance from Main Road Filter
      if (filters['distances'] != null) {
        final distances = filters['distances'] as List;
        if (distances.isNotEmpty) {
          bool matchesDistance = false;

          for (var distance in distances) {
            // Convert distanceToDowntown (in km) to match the ranges
            if (distance == '< 100m' && apt.distanceToDowntown < 0.1) {
              matchesDistance = true;
              break;
            } else if (distance == '100m - 500m' &&
                apt.distanceToDowntown >= 0.1 &&
                apt.distanceToDowntown <= 0.5) {
              matchesDistance = true;
              break;
            } else if (distance == '500m - 1km' &&
                apt.distanceToDowntown > 0.5 &&
                apt.distanceToDowntown <= 1.0) {
              matchesDistance = true;
              break;
            } else if (distance == '1km >' && apt.distanceToDowntown > 1.0) {
              matchesDistance = true;
              break;
            }
          }

          if (!matchesDistance) return false;
        }
      }

      // Bike Price Filter
      if (filters['bikePrices'] != null) {
        final bikePrices = filters['bikePrices'] as List;
        if (bikePrices.isNotEmpty) {
          // Since we don't have a dedicated bike price field,
          // we'll use distance as a proxy (closer = cheaper bike ride)
          bool matchesBikePrice = false;

          for (var price in bikePrices) {
            if (price == '0' && apt.distanceToDowntown < 0.05) {
              matchesBikePrice = true;
              break;
            } else if (price == '100' &&
                apt.distanceToDowntown >= 0.05 &&
                apt.distanceToDowntown < 0.2) {
              matchesBikePrice = true;
              break;
            } else if (price == '200' &&
                apt.distanceToDowntown >= 0.2 &&
                apt.distanceToDowntown < 0.5) {
              matchesBikePrice = true;
              break;
            } else if (price == '300 - 500F' &&
                apt.distanceToDowntown >= 0.5 &&
                apt.distanceToDowntown < 1.0) {
              matchesBikePrice = true;
              break;
            } else if (price == '500F+' && apt.distanceToDowntown >= 1.0) {
              matchesBikePrice = true;
              break;
            }
          }

          if (!matchesBikePrice) return false;
        }
      }

      // Advance Payment Filter
      if (filters['advancePaymentMonths'] != null &&
          filters['advancePaymentMonths'] != 'Any') {
        final advanceMonths = filters['advancePaymentMonths'] as String;

        // Extract number of months
        int months = 1;
        if (advanceMonths.contains('1') || advanceMonths.contains('One')) {
          months = 1;
        } else if (advanceMonths.contains('2') ||
            advanceMonths.contains('Two')) {
          months = 2;
        } else if (advanceMonths.contains('3') ||
            advanceMonths.contains('Three')) {
          months = 3;
        } else if (advanceMonths.contains('6') ||
            advanceMonths.contains('Six')) {
          months = 6;
        } else if (advanceMonths.contains('12') ||
            advanceMonths.contains('Twelve')) {
          months = 12;
        }

        final expectedAdvance = apt.rent * months;
        // Allow 20% tolerance for advance payment matching
        final tolerance = expectedAdvance * 0.2;

        if ((apt.advancePayment - expectedAdvance).abs() > tolerance) {
          return false;
        }
      }

      // Security Deposit Filter
      if (filters['securityDepositMonths'] != null &&
          filters['securityDepositMonths'] != 'Any') {
        final depositMonths = filters['securityDepositMonths'] as String;

        // Extract number of months from property details
        final aptDepositMonths = apt.propertyDetails.depositMonths;

        int expectedMonths = 1;
        if (depositMonths.contains('1') || depositMonths.contains('One')) {
          expectedMonths = 1;
        } else if (depositMonths.contains('2') ||
            depositMonths.contains('Two')) {
          expectedMonths = 2;
        } else if (depositMonths.contains('3') ||
            depositMonths.contains('Three')) {
          expectedMonths = 3;
        }

        // Allow +/- 1 month tolerance
        if ((aptDepositMonths - expectedMonths).abs() > 1) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  /// Apply filters from filter screen
  void applyFilters(Map<String, dynamic>? filters) {
    activeFilters.value = filters;

    if (filters != null) {
      AppLoggerHelper.debug(
        'Filters applied: ${filters.keys.where((key) => filters[key] != null && filters[key] != 'All' && filters[key] != 'Any').join(', ')}',
      );
      AppLoggerHelper.debug(
        'Filtered apartments: ${filteredApartments.length} out of ${apartments.length}',
      );
    }
  }

  /// Clear all advanced filters
  void clearFilters() {
    activeFilters.value = null;
    AppLoggerHelper.debug('All filters cleared');
  }

  /// Check if any advanced filters are active
  bool get hasActiveFilters => activeFilters.value != null;

  /// Get count of active filters
  int get activeFiltersCount {
    if (activeFilters.value == null) return 0;

    int count = 0;
    final filters = activeFilters.value!;

    // Property type
    if (filters['propertyType'] != null && filters['propertyType'] != 'All') {
      count++;
    }

    // Price range (if modified from default)
    if (filters['priceRange'] != null) {
      final priceRange = filters['priceRange'] as Map<String, dynamic>;
      if (priceRange['min'] > 0 || priceRange['max'] < 5000) {
        count++;
      }
    }

    // City
    if (filters['city'] != null && filters['city'] != 'All') {
      count++;
    }

    // Neighborhoods
    if (filters['neighborhoods'] != null &&
        (filters['neighborhoods'] as List).isNotEmpty) {
      count++;
    }

    // Bedrooms
    if (filters['bedrooms'] != null) {
      count++;
    }

    // Bathrooms
    if (filters['bathrooms'] != null) {
      count++;
    }

    // Bike prices
    if (filters['bikePrices'] != null &&
        (filters['bikePrices'] as List).isNotEmpty) {
      count++;
    }

    // Advance payment
    if (filters['advancePaymentMonths'] != null &&
        filters['advancePaymentMonths'] != 'Any') {
      count++;
    }

    // Security deposit
    if (filters['securityDepositMonths'] != null &&
        filters['securityDepositMonths'] != 'Any') {
      count++;
    }

    return count;
  }

  /// Change apartment category filter
  void changeCategory(String type) {
    selectedType.value = type;
  }

  /// Get apartment by ID
  Future<Apartment?> getApartmentById(String id) async {
    try {
      isLoading.value = true;
      return await _apartmentService.getApartmentById(id);
    } catch (e) {
      errorMessage.value = 'Failed to load apartment: ${e.toString()}';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh apartments list
  Future<void> refreshApartments() async {
    await fetchApartments();
  }
}
