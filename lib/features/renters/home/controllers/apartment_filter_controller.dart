import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yannyamba/features/owners/add_property/controllers/city_selection_controller.dart';
import 'package:yannyamba/features/renters/home/controllers/apartment_controller.dart';

class ApartmentFilterController extends GetxController {
  final _selectedPropertyType = 'All'.obs;
  final _priceRange = const RangeValues(0, 5000).obs;
  final _squareFootageRange = const RangeValues(500, 5000).obs;
  final _selectedCity = 'All'.obs;
  final RxSet<String> selectedNeighborhoods = <String>{}.obs;
  final _selectedBedrooms = 'Any'.obs;
  final _selectedBathrooms = 'Any'.obs;
  final _leaseTransferOnly = false.obs;
  final _advancePaymentMonths = 'Any'.obs;
  final _securityDepositMonths = 'Any'.obs;
  final RxSet<String> selectedDistances = <String>{}.obs;
  final RxSet<String> selectedBikePrices = <String>{}.obs;

  String get selectedPropertyType => _selectedPropertyType.value;
  RangeValues get priceRange => _priceRange.value;
  RangeValues get squareFootageRange => _squareFootageRange.value;
  String get selectedCity => _selectedCity.value;
  String get selectedBedrooms => _selectedBedrooms.value;
  String get selectedBathrooms => _selectedBathrooms.value;
  bool get leaseTransferOnly => _leaseTransferOnly.value;
  String get advancePaymentMonths => _advancePaymentMonths.value;
  String get securityDepositMonths => _securityDepositMonths.value;

  void setPropertyType(String value) => _selectedPropertyType.value = value;

  void setPriceRange(RangeValues value) => _priceRange.value = value;

  void setSquareFootageRange(RangeValues value) =>
      _squareFootageRange.value = value;

  void setCity(String value) {
    _selectedCity.value = value;
    // Clear neighborhoods when city changes
    selectedNeighborhoods.clear();
  }

  void toggleNeighborhood(String value) {
    if (selectedNeighborhoods.contains(value)) {
      selectedNeighborhoods.remove(value);
    } else {
      selectedNeighborhoods.add(value);
    }
  }

  void setBedrooms(String value) => _selectedBedrooms.value = value;

  void setBathrooms(String value) => _selectedBathrooms.value = value;

  void setLeaseTransferOnly(bool value) => _leaseTransferOnly.value = value;

  void setAdvancePaymentMonths(String value) =>
      _advancePaymentMonths.value = value;

  void setSecurityDepositMonths(String value) =>
      _securityDepositMonths.value = value;

  void toggleDistance(String value) {
    if (selectedDistances.contains(value)) {
      selectedDistances.remove(value);
    } else {
      selectedDistances.add(value);
    }
  }

  void toggleBikePrice(String value) {
    if (selectedBikePrices.contains(value)) {
      selectedBikePrices.remove(value);
    } else {
      selectedBikePrices.add(value);
    }
  }

  void resetFilters() {
    _selectedPropertyType.value = 'All';
    _priceRange.value = const RangeValues(0, 5000);
    _squareFootageRange.value = const RangeValues(500, 5000);
    _selectedCity.value = 'All';
    selectedNeighborhoods.clear();
    _selectedBedrooms.value = 'Any';
    _selectedBathrooms.value = 'Any';
    _leaseTransferOnly.value = false;
    _advancePaymentMonths.value = 'Any';
    _securityDepositMonths.value = 'Any';
    selectedDistances.clear();
    selectedBikePrices.clear();
  }

  Map<String, dynamic> getFilterData() {
    return {
      'propertyType': _selectedPropertyType.value,
      'priceRange': {
        'min': _priceRange.value.start,
        'max': _priceRange.value.end,
      },
      'squareFootageRange': {
        'min': _squareFootageRange.value.start,
        'max': _squareFootageRange.value.end,
      },
      'city': _selectedCity.value,
      'neighborhoods': selectedNeighborhoods.isNotEmpty
          ? selectedNeighborhoods.toList()
          : null,
      'bedrooms':
          _selectedPropertyType.value != 'Office' &&
              _selectedBedrooms.value != 'Any'
          ? _selectedBedrooms.value
          : null,
      'bathrooms':
          _selectedPropertyType.value != 'Office' &&
              _selectedBathrooms.value != 'Any'
          ? _selectedBathrooms.value
          : null,
      'leaseTransferOnly': _leaseTransferOnly.value,
      'advancePaymentMonths': _advancePaymentMonths.value != 'Any'
          ? _advancePaymentMonths.value
          : null,
      'securityDepositMonths': _securityDepositMonths.value != 'Any'
          ? _securityDepositMonths.value
          : null,
      'distances': selectedDistances.isNotEmpty
          ? selectedDistances.toList()
          : null,
      'bikePrices': selectedBikePrices.isNotEmpty
          ? selectedBikePrices.toList()
          : null,
    };
  }

  /// Get available cities from CitySelectionController
  List<String> get availableCities {
    final cityController = Get.find<CitySelectionController>();
    return ['All', ...cityController.cities];
  }

  /// Get available neighborhoods from loaded apartments
  List<String> get availableNeighborhoods {
    final apartmentController = Get.find<ApartmentController>();
    final neighborhoods = apartmentController.apartments
        .where((apt) {
          if (_selectedCity.value == 'All' || _selectedCity.value.isEmpty) {
            return true;
          }

          return apt.address.city.toLowerCase().trim() ==
              _selectedCity.value.toLowerCase().trim();
        })
        .map((apt) => apt.address.street.trim())
        .where((street) => street.isNotEmpty)
        .toSet()
        .toList();

    neighborhoods.sort();
    return neighborhoods;
  }
}
