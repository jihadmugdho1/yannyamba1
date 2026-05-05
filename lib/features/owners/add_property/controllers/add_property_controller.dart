import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:yannyamba/features/owners/add_property/data/services/add_property_service.dart';
import 'package:yannyamba/features/owners/add_property/presentation/widgets/show_lottie.dart';
import 'package:yannyamba/features/owners/dashboard/controllers/owner_dashboard_controller.dart';
import 'package:yannyamba/features/owners/dashboard/data/models/owner_property_model.dart';
import 'package:yannyamba/features/owners/dashboard/data/models/dashboard_stats_model.dart';
import 'package:yannyamba/features/owners/controllers/owner_navigation_controller.dart';
import 'package:yannyamba/core/models/property/property_models.dart';
import 'package:yannyamba/features/owners/add_property/data/models/reference_model.dart';
import 'package:yannyamba/features/renters/home/controllers/apartment_controller.dart';
import 'package:yannyamba/features/renters/furnished_apartments/controllers/furnished_apartment_controller.dart';
import 'package:yannyamba/core/utils/logging/logger.dart';

class AddPropertyController extends GetxController {
  final AddPropertyService _propertyService = AddPropertyService();

  final isSubmitting = false.obs;
  final uploadProgress = 0.0.obs;
  final uploadStatus = ''.obs;

  final currentStep = 0.obs;

  // Auto-computed: 'furnished' = short term (min ≤ 15), 'normal' = long term (min ≥ 16)
  final listingType = 'furnished'.obs;

  final propertyType = ''.obs;
  final bedrooms = 1.obs;
  final bathrooms = 1.obs;
  final officeRooms = 1.obs;
  final conferenceRooms = 0.obs;
  final workstations = 1.obs;
  final propertySize = ''.obs;
  final aboutRental = ''.obs;
  final isLeaseTakeover = false.obs;
  final aboutRentalController = TextEditingController();
  final propertySizeController = TextEditingController();

  final monthlyRent = ''.obs;
  final advanceMonths = 1.obs;
  final securityMonths = 1.obs;
  final monthlyRentController = TextEditingController();

  final dailyRate = ''.obs;
  final dailyRateController = TextEditingController();
  final minimumStay = 1.obs;
  final maximumStay = 15.obs;
  final checkInTime = '14:00'.obs;
  final checkOutTime = '11:00'.obs;

  final cityName = ''.obs;
  final neighbourhood = ''.obs;
  final distanceToDowntown = ''.obs; // Changed from distanceFromRoad
  final nearbyLandmarks = ''.obs;
  final neighbourhoodController = TextEditingController();
  final distanceToDowntownController = TextEditingController(); // Changed name
  final nearbyLandmarksController = TextEditingController();

  final selectedFeatures = <String>[].obs;
  final selectedAmenities = <String>[].obs;

  final selectedFurnishings = <String>[].obs;
  final selectedHouseRules = <String>[].obs;

  final propertyPhotos = <String>[].obs; // Store image paths

  final ownerName = ''.obs;
  final ownerNumber = ''.obs;
  final references = <ReferenceModel>[].obs;

  final Rx<CountryCode> ownerCountryCode = CountryCode(
    dialCode: '+237',
    code: 'CM',
    name: 'Cameroon',
  ).obs;

  final RxList<CountryCode> referenceCountryCodes = <CountryCode>[].obs;

  final isStep1Valid = false.obs;
  final isStep2Valid = false.obs;
  final isStep3Valid = false.obs;
  final isStep4Valid = false.obs;
  final isStep5Valid = false.obs;
  final isStep6Valid = false.obs;

  @override
  void onInit() {
    super.onInit();

    references.add(
      ReferenceModel(
        name: '',
        phoneNumber: '',
        relationship: RelationshipTypes.neighbour,
      ),
    );

    referenceCountryCodes.add(
      CountryCode(dialCode: '+237', code: 'CM', name: 'Cameroon'),
    );

    // Auto-detect short/long term from minimum stay days
    ever(minimumStay, (val) {
      listingType.value = val <= 15 ? 'furnished' : 'normal';
    });

    aboutRentalController.addListener(() {
      aboutRental.value = aboutRentalController.text;
    });

    propertySizeController.addListener(() {
      propertySize.value = propertySizeController.text;
    });

    monthlyRentController.addListener(() {
      monthlyRent.value = monthlyRentController.text;
    });

    neighbourhoodController.addListener(() {
      neighbourhood.value = neighbourhoodController.text;
    });

    distanceToDowntownController.addListener(() {
      distanceToDowntown.value = distanceToDowntownController.text;
    });

    nearbyLandmarksController.addListener(() {
      nearbyLandmarks.value = nearbyLandmarksController.text;
    });

    dailyRateController.addListener(() {
      dailyRate.value = dailyRateController.text;
    });
  }

  @override
  void onClose() {
    aboutRentalController.dispose();
    propertySizeController.dispose();
    monthlyRentController.dispose();
    neighbourhoodController.dispose();
    distanceToDowntownController.dispose();
    nearbyLandmarksController.dispose();
    dailyRateController.dispose();
    super.onClose();
  }

  void nextStep() {
    if (currentStep.value < 5) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 5) {
      currentStep.value = step;
    }
  }

  bool validateStep1() {
    final hasValidSize =
        double.tryParse(propertySize.value) != null &&
        double.tryParse(propertySize.value)! > 0;
    final hasAbout = aboutRental.value.trim().isNotEmpty;

    if (propertyType.value == 'Office') {
      isStep1Valid.value =
          propertyType.value.isNotEmpty &&
          officeRooms.value > 0 &&
          workstations.value > 0 &&
          hasValidSize &&
          hasAbout;
    } else {
      isStep1Valid.value =
          propertyType.value.isNotEmpty &&
          bedrooms.value > 0 &&
          bathrooms.value > 0 &&
          hasValidSize &&
          hasAbout;
    }
    return isStep1Valid.value;
  }

  bool validateStep2() {
    isStep2Valid.value = dailyRate.value.isNotEmpty;
    return isStep2Valid.value;
  }

  bool validateStep3() {
    isStep3Valid.value =
        cityName.value.isNotEmpty &&
        neighbourhood.value.isNotEmpty &&
        nearbyLandmarks.value.trim().isNotEmpty;
    return isStep3Valid.value;
  }

  bool validateStep4() {
    if (listingType.value == 'furnished') {
      isStep4Valid.value =
          selectedFurnishings.isNotEmpty || selectedHouseRules.isNotEmpty;
    } else {
      isStep4Valid.value =
          selectedFeatures.isNotEmpty || selectedAmenities.isNotEmpty;
    }
    return isStep4Valid.value;
  }

  bool validateStep5() {
    isStep5Valid.value = propertyPhotos.isNotEmpty;
    return isStep5Valid.value;
  }

  bool validateStep6() {
    bool ownerValid =
        ownerName.value.isNotEmpty && ownerNumber.value.isNotEmpty;

    bool firstReferenceValid = true; // Default to true for furnished apartments
    if (listingType.value != 'furnished' && references.isNotEmpty) {
      final firstRef = references.first;
      firstReferenceValid =
          firstRef.name.isNotEmpty && firstRef.phoneNumber.isNotEmpty;
    }

    isStep6Valid.value = ownerValid && firstReferenceValid;
    return isStep6Valid.value;
  }

  void addPhoto(String path) {
    if (propertyPhotos.length < 10) {
      propertyPhotos.add(path);
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < propertyPhotos.length) {
      propertyPhotos.removeAt(index);
    }
  }

  void toggleFeature(String feature) {
    if (selectedFeatures.contains(feature)) {
      selectedFeatures.remove(feature);
    } else {
      selectedFeatures.add(feature);
    }
  }

  void toggleAmenity(String amenity) {
    if (selectedAmenities.contains(amenity)) {
      selectedAmenities.remove(amenity);
    } else {
      selectedAmenities.add(amenity);
    }
  }

  void toggleFurnishing(String furnishing) {
    if (selectedFurnishings.contains(furnishing)) {
      selectedFurnishings.remove(furnishing);
    } else {
      selectedFurnishings.add(furnishing);
    }
  }

  void toggleHouseRule(String rule) {
    if (selectedHouseRules.contains(rule)) {
      selectedHouseRules.remove(rule);
    } else {
      selectedHouseRules.add(rule);
    }
  }

  /// Add a new reference
  void addReference() {
    // Maximum 2 references (1 mandatory + 1 optional)
    if (references.length < 2) {
      references.add(
        ReferenceModel(
          name: '',
          phoneNumber: '',
          relationship: RelationshipTypes.neighbour,
        ),
      );
      // Also add corresponding country code
      addReferenceCountryCode();
    }
  }

  /// Remove a reference at index
  void removeReference(int index) {
    // Prevent removing the first (mandatory) reference
    if (index > 0 && index < references.length) {
      references.removeAt(index);
      // Also remove corresponding country code
      removeReferenceCountryCode(index);
    }
  }

  /// Update reference at index
  void updateReference(int index, ReferenceModel reference) {
    if (index >= 0 && index < references.length) {
      references[index] = reference;
    }
  }

  /// Update owner country code
  void updateOwnerCountryCode(CountryCode countryCode) {
    ownerCountryCode.value = countryCode;
  }

  /// Update reference country code at index
  void updateReferenceCountryCode(int index, CountryCode countryCode) {
    if (index >= 0 && index < referenceCountryCodes.length) {
      referenceCountryCodes[index] = countryCode;
    }
  }

  /// Add country code for new reference
  void addReferenceCountryCode() {
    referenceCountryCodes.add(
      CountryCode(dialCode: '+237', code: 'CM', name: 'Cameroon'),
    );
  }

  /// Remove country code for reference at index
  void removeReferenceCountryCode(int index) {
    if (index > 0 && index < referenceCountryCodes.length) {
      referenceCountryCodes.removeAt(index);
    }
  }

  /// Reset all data
  void reset() {
    currentStep.value = 0;
    listingType.value = 'furnished';
    propertyType.value = '';
    bedrooms.value = 1;
    bathrooms.value = 1;
    officeRooms.value = 1;
    conferenceRooms.value = 0;
    workstations.value = 1;
    propertySize.value = '';
    propertySizeController.clear();
    aboutRental.value = '';
    aboutRentalController.clear();
    isLeaseTakeover.value = false;
    monthlyRent.value = '';
    monthlyRentController.clear();
    advanceMonths.value = 1;
    securityMonths.value = 1;
    dailyRate.value = '';
    dailyRateController.clear();
    minimumStay.value = 1;
    maximumStay.value = 15;
    checkInTime.value = '14:00';
    checkOutTime.value = '11:00';
    cityName.value = '';
    neighbourhood.value = '';
    neighbourhoodController.clear();
    distanceToDowntown.value = '';
    distanceToDowntownController.clear();
    nearbyLandmarks.value = '';
    nearbyLandmarksController.clear();
    selectedFeatures.clear();
    selectedAmenities.clear();
    selectedFurnishings.clear();
    selectedHouseRules.clear();
    propertyPhotos.clear();
    ownerName.value = '';
    ownerNumber.value = '';
    references.clear();

    // Reset country codes
    ownerCountryCode.value = CountryCode(
      dialCode: '+237',
      code: 'CM',
      name: 'Cameroon',
    );
    referenceCountryCodes.clear();

    // Re-add mandatory reference after reset
    references.add(
      ReferenceModel(
        name: '',
        phoneNumber: '',
        relationship: RelationshipTypes.neighbour,
      ),
    );

    // Re-initialize country codes for references
    referenceCountryCodes.add(
      CountryCode(dialCode: '+237', code: 'CM', name: 'Cameroon'),
    );
  }

  void _showErrorSnackbar(ScaffoldMessengerState messenger, String message) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFEF4444),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Submit property with real-time dashboard update
  Future<void> submitProperty(BuildContext context) async {
    // Capture messenger and lottie context before any async gap
    final messenger = ScaffoldMessenger.of(context);

    if (!validateStep6()) {
      _showErrorSnackbar(messenger, 'Please fill all required fields');
      return;
    }

    isSubmitting.value = true;
    uploadStatus.value = 'Uploading photos...';
    uploadProgress.value = 0.0;

    try {
      final isLongTerm = minimumStay.value >= 16;

      final result = await _propertyService.publishProperty(
        propertyType: propertyType.value,
        bedrooms: propertyType.value == 'Office'
            ? officeRooms.value
            : bedrooms.value,
        bathrooms: propertyType.value == 'Office'
            ? conferenceRooms.value
            : bathrooms.value,
        propertySize: propertySize.value,
        aboutRental: aboutRental.value,
        dailyRate: dailyRate.value,
        minimumStay: minimumStay.value,
        maximumStay: maximumStay.value,
        cityName: cityName.value,
        neighbourhood: neighbourhood.value,
        distanceToDowntown: distanceToDowntown.value.isEmpty
            ? null
            : distanceToDowntown.value,
        nearbyLandmarks: nearbyLandmarks.value.isEmpty
            ? null
            : nearbyLandmarks.value,
        selectedFeatures: selectedFeatures.toList(),
        selectedAmenities: selectedAmenities.toList(),
        selectedHouseRules: selectedHouseRules.toList(),
        selectedWhatsIncluded: selectedFurnishings.toList(),
        photoLocalPaths: propertyPhotos.toList(),
        ownerName: ownerName.value,
        ownerNumber: ownerNumber.value,
        references: references.toList(),
        workstations: propertyType.value == 'Office' ? workstations.value : null,
        advanceMonths: isLongTerm ? advanceMonths.value : null,
        securityMonths: isLongTerm ? securityMonths.value : null,
      );

      uploadStatus.value = 'Creating property listing...';
      uploadProgress.value = 1.0;

      if (result.isSuccess) {
        try {
          // Convert API response to OwnerProperty model
          final propertyData = result.data!;
          final newProperty = _convertToOwnerProperty(propertyData);

          // Update dashboard reactively using Rx
          final dashboardController = Get.find<OwnerDashboardController>();

          // Add new property to the reactive list
          dashboardController.properties.insert(0, newProperty);

          // Update dashboard stats reactively
          final currentStats = dashboardController.dashboardStats.value;
          if (currentStats != null) {
            dashboardController.dashboardStats.value = DashboardStats(
              totalProperties: currentStats.totalProperties + 1,
              activeListings: currentStats.activeListings + 1,
              totalViews: currentStats.totalViews,
              inquiries: currentStats.inquiries,
            );
          }

          // Also add the property to the Renter's Home Screen
          // Convert OwnerProperty to Apartment for renter's view
          _syncToRenterHomeScreen(newProperty, propertyData);

          // Show success lottie animation BEFORE navigation
          showSuccessLottie(context);

          // Wait a moment to ensure dialog is shown
          await Future.delayed(const Duration(milliseconds: 500));

          // Reset form
          reset();

          // Navigate to dashboard tab after a delay
          Future.delayed(const Duration(milliseconds: 500), () {
            final navController = Get.find<OwnerNavigationController>();
            final ownerDashboardController =
                Get.find<OwnerDashboardController>();
            ownerDashboardController.refreshDashboard();
            navController.goToDashboard();
          });
        } catch (conversionError) {
          _showErrorSnackbar(
            messenger,
            'Property saved but display error: $conversionError',
          );
        }
      } else {
        final errorMsg = result.error ?? 'Failed to publish property';
        AppLoggerHelper.error('Publish property failed', errorMsg);
        _showErrorSnackbar(messenger, errorMsg);
      }
    } catch (e) {
      AppLoggerHelper.error('Publish property exception', e);
      _showErrorSnackbar(messenger, 'An unexpected error occurred: $e');
    } finally {
      isSubmitting.value = false;
      uploadStatus.value = '';
      uploadProgress.value = 0.0;
    }
  }

  /// Convert API response to OwnerProperty model
  OwnerProperty _convertToOwnerProperty(Map<String, dynamic> data) {
    final location = data['location'] as Map<String, dynamic>;
    final owner = data['owner'] as Map<String, dynamic>;
    final photos = (data['photos'] as List).cast<String>();
    final bedrooms = data['bedrooms'] as int;
    final isOffice = data['propertyType'] == 'Office';

    // Get actual square feet from data, fallback to estimate
    final actualSquareFeet = (data['squareFeet'] as num?)?.toDouble();
    final squareFeet = actualSquareFeet ?? (bedrooms * 600.0);

    // Get actual distance to downtown from location data
    final actualDistance = (location['distanceToDowntown'] as num?)?.toDouble();
    final distanceToDowntown = actualDistance ?? 0.0;

    // Short term = furnished, long term = normal
    final isFurnished = data['listingType'] == 'furnished';

    // Create address object
    final address = Address(
      street: location['neighbourhood'] as String,
      city: location['cityName'] as String,
      state: '', // Add state if available
      zipCode: '', // Add zip if available
      latitude: 0.0, // Add coordinates if available
      longitude: 0.0,
    );

    // Create owner contact
    final ownerContact = Contact.owner(
      name: owner['name'] as String,
      phone: owner['phoneNumber'] as String,
      email: '', // Add email if available
      isVerified: false,
    );

    // Create reference contacts if exist
    final contacts = <Contact>[ownerContact];
    if (data['references'] != null) {
      final refs = data['references'] as List;
      for (final refData in refs) {
        final ref = refData as Map<String, dynamic>;
        if (ref['name'].toString().isNotEmpty) {
          contacts.add(
            Contact.reference(
              name: ref['name'] as String,
              phone: (ref['phone'] ?? ref['phoneNumber'] ?? '') as String,
              email: '',
              relationship: ref['relationship'] as String,
            ),
          );
        }
      }
    }

    final propertyDetails = PropertyDetails(
      propertyType: data['propertyType'] as String,
      squareFeet: squareFeet,
      advanceMonths: (data['advanceMonths'] as int?) ?? 0,
      depositMonths: (data['securityMonths'] as int?) ?? 0,
      distanceToDowntown: distanceToDowntown,
    );

    final stayLabel = isFurnished ? 'Short-term' : 'Long-term';
    final detailsString = '''
${data['aboutRental'] ?? ''}

$stayLabel Rental
Daily Rate: ₣ ${data['dailyRate'] ?? 0}/night
Min Stay: ${data['minimumStay'] ?? 1} days | Max Stay: ${data['maximumStay'] ?? 15} days
${!isFurnished ? 'Advance: ${data['advanceMonths'] ?? 0} month(s) | Security: ${data['securityMonths'] ?? 0} month(s)' : ''}
${isOffice && data['workstations'] != null ? '💼 Workstations: ${data['workstations']}' : ''}
📍 Location: ${location['neighbourhood']}, ${location['cityName']}
${distanceToDowntown > 0 ? '📍 Distance: $distanceToDowntown miles to main road' : ''}
${location['nearbyLandmarks'] != null ? '📍 Nearby: ${location['nearbyLandmarks']}' : ''}
''';

    final features = (data['features'] as List?)?.cast<String>() ?? [];
    final amenities = (data['amenities'] as List?)?.cast<String>() ?? [];
    final rentDisplay = (data['dailyRate'] as num?)?.toDouble() ?? 0.0;

    // Title with property type indicator
    final title = isFurnished
        ? '$bedrooms Bedrooms ${data['propertyType']}  - ${location['neighbourhood']}'
        : isOffice
        ? '${data['workstations'] ?? bedrooms} Workstations Office Space - ${location['neighbourhood']}'
        : '$bedrooms Bedrooms ${data['propertyType']} in ${location['neighbourhood']}';

    return OwnerProperty(
      id: data['id'] as String,
      title: title,
      address: address,
      type: data['propertyType'] as String,
      rent: rentDisplay,
      advancePayment: (data['advanceAmount'] as num?)?.toDouble() ?? 0.0,
      size: squareFeet,
      rooms: bedrooms,
      washrooms: data['bathrooms'] as int,
      distanceToDowntown: distanceToDowntown,
      images: photos,
      contacts: contacts,
      about: (data['aboutRental'] ?? '') as String,
      propertyDetails: propertyDetails,
      features: features,
      amenities: amenities,
      details: detailsString,
      views: data['views'] as int? ?? 0,
      inquiries: data['inquiries'] as int? ?? 0,
      isActive: data['status'] == 'active',
    );
  }

  /// Sync newly added property to Renter's Home Screen
  /// This makes owner-added properties immediately visible to renters
  void _syncToRenterHomeScreen(
    OwnerProperty ownerProperty,
    Map<String, dynamic> propertyData,
  ) {
    try {
      // Try to get the ApartmentController if it exists (renter logged in)
      if (Get.isRegistered<ApartmentController>()) {
        final apartmentController = Get.find<ApartmentController>();

        // Check if this is a furnished apartment
        final isFurnished = listingType.value == 'furnished';

        // Convert OwnerProperty to Apartment (for regular apartments)
        // or FurnishedApartment (for furnished apartments)
        if (isFurnished) {
          // Create FurnishedApartment for furnished listings
          final furnishedApartment = FurnishedApartment(
            id: ownerProperty.id,
            title: ownerProperty.title,
            address: ownerProperty.address,
            type: ownerProperty.type,
            rent: ownerProperty.rent,
            advancePayment: ownerProperty.advancePayment,
            size: ownerProperty.size,
            rooms: ownerProperty.rooms,
            washrooms: ownerProperty.washrooms,
            distanceToDowntown: ownerProperty.distanceToDowntown,
            images: ownerProperty.images,
            contacts: ownerProperty.contacts,
            about: ownerProperty.about,
            propertyDetails: ownerProperty.propertyDetails,
            features: ownerProperty.features,
            amenities: ownerProperty.amenities,
            details: ownerProperty.details,
            dailyRate: propertyData['dailyRate'] as double,
            minimumStay: propertyData['minimumStay'] as int? ?? 1,
            maximumStay: propertyData['maximumStay'] as int? ?? 30,
            blockedDates: [],
            bookings: [],
            furnishings:
                (propertyData['furnishings'] as List?)?.cast<String>() ?? [],
            checkInTime: propertyData['checkInTime'] as String? ?? '14:00',
            checkOutTime: propertyData['checkOutTime'] as String? ?? '11:00',
            cancellationPolicy:
                'Flexible - Full refund 24 hours before check-in',
            houseRules:
                (propertyData['houseRules'] as List?)?.cast<String>() ?? [],
          );

          // Also sync to FurnishedApartmentController if it exists
          if (Get.isRegistered<FurnishedApartmentController>()) {
            final furnishedController =
                Get.find<FurnishedApartmentController>();
            furnishedController.apartments.insert(0, furnishedApartment);
          }
        } else {
          // Create regular Apartment for normal listings
          final apartment = Apartment(
            id: ownerProperty.id,
            title: ownerProperty.title,
            address: ownerProperty.address,
            type: ownerProperty.type,
            rent: ownerProperty.rent,
            advancePayment: ownerProperty.advancePayment,
            size: ownerProperty.size,
            rooms: ownerProperty.rooms,
            washrooms: ownerProperty.washrooms,
            distanceToDowntown: ownerProperty.distanceToDowntown,
            images: ownerProperty.images,
            contacts: ownerProperty.contacts,
            about: ownerProperty.about,
            propertyDetails: ownerProperty.propertyDetails,
            features: ownerProperty.features,
            amenities: ownerProperty.amenities,
            details: ownerProperty.details,
          );

          // Add to the beginning of the list (most recent first)
          apartmentController.apartments.insert(0, apartment);
        }
      }
    } catch (e) {
      // If ApartmentController doesn't exist, that's fine
      // It will be loaded when renter navigates to home screen
    }
  }
}
