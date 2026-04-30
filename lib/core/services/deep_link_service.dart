import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yannyamba/core/core.dart';
import 'package:yannyamba/features/renters/furnished_apartments/controllers/furnished_apartment_controller.dart';
import 'package:yannyamba/features/renters/furnished_apartments/presentation/screens/furnished_apartment_details_screen.dart';
import 'package:yannyamba/features/renters/home/controllers/apartment_controller.dart';
import 'package:yannyamba/features/renters/home/presentation/screens/view_details.dart';

/// Service to handle deep links for apartment details
/// Supports yannyamba://apartment/{id} and yannyamba://furnished/{id}
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final _appLinks = AppLinks();
  Uri? _pendingUri;
  bool _isInitialized = false;

  /// Initialize deep link handling
  /// Call this in main.dart after app is ready
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Handle initial link if app was opened from a deep link (cold start)
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        AppLoggerHelper.debug(
          '📱 Initial deep link received (cold start): $initialUri',
        );
        _pendingUri = initialUri;
        // Don't process immediately - wait for app to be fully ready
        // The processPendingLink method will be called after controllers are initialized
      }

      // Listen for links while app is running (warm start)
      _appLinks.uriLinkStream.listen(
        (uri) {
          AppLoggerHelper.debug('📱 Deep link received (warm start): $uri');
          // Store it and process with delay to ensure context is ready
          _pendingUri = uri;
          Future.delayed(const Duration(milliseconds: 500), () {
            processPendingLink();
          });
        },
        onError: (err) {
          AppLoggerHelper.error('Deep link error', err);
        },
      );

      _isInitialized = true;
      AppLoggerHelper.debug('✅ Deep link service initialized');
    } catch (e) {
      AppLoggerHelper.error('Failed to initialize deep link service', e);
    }
  }

  /// Process pending deep link after app is fully initialized
  /// Call this from MainScreen after controllers are ready
  void processPendingLink() {
    if (_pendingUri != null) {
      AppLoggerHelper.debug('🚀 Processing pending deep link: $_pendingUri');

      // Check if GetX context is ready before proceeding
      if (Get.context == null) {
        AppLoggerHelper.debug('⚠️ GetX context not ready yet, will retry...');
        // Retry after a delay
        Future.delayed(const Duration(milliseconds: 500), () {
          processPendingLink();
        });
        return;
      }

      final uri = _pendingUri!;
      _pendingUri = null; // Clear it first to avoid double processing

      // Add a small delay to ensure UI is fully rendered
      Future.delayed(const Duration(milliseconds: 300), () {
        _handleDeepLink(uri);
      });
    }
  }

  /// Handle incoming deep link
  void _handleDeepLink(Uri uri) {
    try {
      AppLoggerHelper.debug(
        '🔗 Parsing deep link - Scheme: ${uri.scheme}, Host: ${uri.host}, Path: ${uri.path}',
      );

      // Support multiple schemes: yannyamba://, http://, https://
      String? type;
      String? id;

      if (uri.scheme == 'yannyamba') {
        // Format: yannyamba://apartment/123 or yannyamba://furnished/123
        type = uri.host; // 'apartment' or 'furnished'
        id = uri.path.replaceFirst('/', ''); // Remove leading slash
      } else if (uri.scheme == 'http' || uri.scheme == 'https') {
        // Format: http://yannyamba/apartment/123 or https://yannyamba/apartment/123
        if (uri.host == 'yannyamba') {
          final pathSegments = uri.pathSegments;
          if (pathSegments.length >= 2) {
            type = pathSegments[0]; // 'apartment' or 'furnished'
            id = pathSegments[1]; // apartment ID
          }
        }
      }

      if (type == null || id == null || id.isEmpty) {
        AppLoggerHelper.error('Invalid deep link format', 'Missing type or ID');
        return;
      }

      AppLoggerHelper.debug('🏠 Apartment type: $type, ID: $id');

      // Check if GetX context is ready with retry mechanism
      _navigateWithRetry(type, id, maxRetries: 5);
    } catch (e) {
      AppLoggerHelper.error('Error handling deep link', e);
    }
  }

  /// Navigate with retry mechanism to ensure GetX is ready
  void _navigateWithRetry(
    String type,
    String id, {
    int maxRetries = 5,
    int currentRetry = 0,
  }) {
    // Check if controllers are registered
    if (!Get.isRegistered<ApartmentController>() ||
        !Get.isRegistered<FurnishedApartmentController>()) {
      if (currentRetry < maxRetries) {
        AppLoggerHelper.debug(
          '⚠️ Controllers not ready, retry ${currentRetry + 1}/$maxRetries...',
        );
        Future.delayed(Duration(milliseconds: 300 * (currentRetry + 1)), () {
          _navigateWithRetry(
            type,
            id,
            maxRetries: maxRetries,
            currentRetry: currentRetry + 1,
          );
        });
        return;
      } else {
        AppLoggerHelper.error(
          'Controllers not initialized after $maxRetries retries',
          'Deep link navigation failed',
        );
        // Just log the error, don't show snackbar as it can crash
        return;
      }
    }

    // Controllers are ready, navigate based on type
    if (type == 'apartment') {
      _navigateToNormalApartment(id);
    } else if (type == 'furnished') {
      _navigateToFurnishedApartment(id);
    } else {
      AppLoggerHelper.error('Unknown apartment type', type);
    }
  }

  /// Navigate to normal apartment details
  Future<void> _navigateToNormalApartment(String id) async {
    try {
      AppLoggerHelper.debug('🏢 Navigating to normal apartment: $id');

      final controller = Get.find<ApartmentController>();

      // Check if apartment is already in the list
      final existingApartment = controller.apartments.firstWhereOrNull(
        (apt) => apt.id == id,
      );

      if (existingApartment != null) {
        // Navigate immediately if found
        AppLoggerHelper.debug('✅ Apartment found in cache, navigating...');
        if (Get.context != null) {
          Get.to(() => ViewDetails(apartmentId: id));
        }
      } else {
        // Fetch apartments and then navigate
        AppLoggerHelper.debug('🔄 Apartment not in cache, fetching...');

        // Show loading indicator only if context is ready
        if (Get.context != null) {
          Get.dialog(
            const Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );
        }

        await controller.fetchApartments();

        // Close loading
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        // Check again after fetching
        final apartment = controller.apartments.firstWhereOrNull(
          (apt) => apt.id == id,
        );

        if (apartment != null) {
          AppLoggerHelper.debug('✅ Apartment found after fetch, navigating...');
          if (Get.context != null) {
            Get.to(() => ViewDetails(apartmentId: id));
          }
        } else {
          AppLoggerHelper.error('Apartment not found', id);
          // Just log, don't show snackbar as it might crash if context isn't fully ready
        }
      }
    } catch (e) {
      AppLoggerHelper.error('Error navigating to normal apartment', e);
      if (Get.isDialogOpen ?? false) {
        try {
          Get.back();
        } catch (_) {
          // Ignore if back fails
        }
      }
      // Don't show snackbar, just log the error
    }
  }

  /// Navigate to furnished apartment details
  Future<void> _navigateToFurnishedApartment(String id) async {
    try {
      AppLoggerHelper.debug('🛋️ Navigating to furnished apartment: $id');

      final controller = Get.find<FurnishedApartmentController>();

      // Check if apartment is already in the list
      final existingApartment = controller.apartments.firstWhereOrNull(
        (apt) => apt.id == id,
      );

      if (existingApartment != null) {
        // Navigate immediately if found
        AppLoggerHelper.debug(
          '✅ Furnished apartment found in cache, navigating...',
        );
        if (Get.context != null) {
          Get.to(() => FurnishedApartmentDetailsScreen(apartmentId: id));
        }
      } else {
        // Fetch apartments and then navigate
        AppLoggerHelper.debug(
          '🔄 Furnished apartment not in cache, fetching...',
        );

        // Show loading indicator only if context is ready
        if (Get.context != null) {
          Get.dialog(
            const Center(child: CircularProgressIndicator()),
            barrierDismissible: false,
          );
        }

        await controller.fetchFurnishedApartments();

        // Close loading
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        // Check again after fetching
        final apartment = controller.apartments.firstWhereOrNull(
          (apt) => apt.id == id,
        );

        if (apartment != null) {
          AppLoggerHelper.debug(
            '✅ Furnished apartment found after fetch, navigating...',
          );
          if (Get.context != null) {
            Get.to(() => FurnishedApartmentDetailsScreen(apartmentId: id));
          }
        } else {
          AppLoggerHelper.error('Furnished apartment not found', id);
          // Just log, don't show snackbar as it might crash if context isn't fully ready
        }
      }
    } catch (e) {
      AppLoggerHelper.error('Error navigating to furnished apartment', e);
      if (Get.isDialogOpen ?? false) {
        try {
          Get.back();
        } catch (_) {
          // Ignore if back fails
        }
      }
      // Don't show snackbar, just log the error
    }
  }

  /// Generate a deep link for an apartment
  /// Backend can use these formats:
  /// - yannyamba://apartment/{id} or yannyamba://furnished/{id}
  /// - http://yannyamba/apartment/{id} or http://yannyamba/furnished/{id}
  /// - https://yannyamba/apartment/{id} or https://yannyamba/furnished/{id}
  ///
  /// For WhatsApp sharing, use http:// or https:// format (clickable links)
  static String generateApartmentLink(
    String id, {
    bool isFurnished = false,
    bool useHttpScheme = true, // Use http by default for clickable links
  }) {
    final type = isFurnished ? 'furnished' : 'apartment';

    if (useHttpScheme) {
      return 'https://yannyamba/$type/$id';
    } else {
      return 'yannyamba://$type/$id';
    }
  }

  /// Get pending URI (useful for debugging)
  Uri? get pendingUri => _pendingUri;

  /// Clear pending URI
  void clearPendingUri() {
    _pendingUri = null;
  }
}
