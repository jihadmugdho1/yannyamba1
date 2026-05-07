import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import '../data/services/authentication_service.dart';
import '../../../common/navigation/navigation_helper.dart';
import '../../../owners/dashboard/controllers/owner_dashboard_controller.dart';
import '../../../owners/bookings/controllers/owner_bookings_controller.dart';
import '../../../renters/AI/controllers/chat_controller.dart';

enum AuthMode { login, register }

class AuthenticationController extends GetxController {
  AuthenticationController({required this.authenticationService});

  final AuthenticationService authenticationService;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  final Rx<AuthMode> currentMode = AuthMode.login.obs;
  final RxBool isProcessing = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoggedIn = false.obs;
  final RxnString generatedCode = RxnString();

  // Country code selection
  final Rx<CountryCode> selectedCountryCode = CountryCode(
    dialCode: '+237',
    code: 'CM',
    name: 'Cameroon',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialState();
    ever<bool>(isLoggedIn, (loggedIn) {
      if (!loggedIn) return;
      currentMode.value = AuthMode.login;
      resetFlow();
      Future.microtask(
        () => NavigationHelper.handlePostLoginNavigation(
          authenticationService: authenticationService,
        ),
      );
    });
  }

  @override
  void onClose() {
    phoneController.dispose();
    codeController.dispose();
    super.onClose();
  }

  void switchToLogin({bool clearPhone = false}) {
    currentMode.value = AuthMode.login;
    resetFlow(clearPhone: clearPhone);
  }

  void switchToRegister({bool clearPhone = false}) {
    currentMode.value = AuthMode.register;
    resetFlow(clearPhone: clearPhone);
  }

  /// Get the full phone number with country code
  String _getFullPhoneNumber() {
    final phoneNumber = phoneController.text.trim();
    if (phoneNumber.isEmpty) return '';

    final countryCode = selectedCountryCode.value.dialCode ?? '+91';
    return '$countryCode$phoneNumber';
  }

  /// Update selected country code
  void updateCountryCode(CountryCode countryCode) {
    selectedCountryCode.value = countryCode;
  }

  Future<bool> login() async {
    final phoneNumber = _getFullPhoneNumber();

    if (phoneNumber.isEmpty) {
      errorMessage.value = 'Please enter a phone number';
      return false;
    }

    var success = false;
    await _withLoader(() async {
      try {
        await authenticationService.login(phoneNumber);
        errorMessage.value = '';
        success = true;
      } on AuthenticationException catch (exception) {
        errorMessage.value = exception.message;
      } catch (_) {
        errorMessage.value = 'Something went wrong. Please try again.';
      }
    });
    return success;
  }

  Future<bool> sendVerificationCode() async {
    final phoneNumber = _getFullPhoneNumber();

    if (phoneNumber.isEmpty) {
      errorMessage.value = 'Please enter a phone number';
      return false;
    }

    var success = false;
    await _withLoader(() async {
      try {
        await authenticationService.requestVerificationCode(phoneNumber);
        errorMessage.value = '';
        success = true;
      } on AuthenticationException catch (exception) {
        errorMessage.value = exception.message;
      } catch (_) {
        errorMessage.value =
            'We could not send a verification code. Please try again.';
      }
    });
    return success;
  }

  Future<bool> verifyCodeAndRegister() async {
    final code = codeController.text.trim();

    if (code.isEmpty) {
      errorMessage.value = 'Please enter the verification code';
      return false;
    }

    if (code.length != 6) {
      errorMessage.value = 'Please enter a valid 6-digit code';
      return false;
    }

    var success = false;
    await _withLoader(() async {
      try {
        final didVerify = await authenticationService.verifyCode(code);
        if (didVerify) {
          isLoggedIn.value = true;
          generatedCode.value = null;
          codeController.clear();
          errorMessage.value = '';
          success = true;
        } else {
          errorMessage.value = 'The verification code is incorrect.';
        }
      } on AuthenticationException catch (exception) {
        errorMessage.value = exception.message;
      } catch (_) {
        errorMessage.value = 'Verification failed. Please try again.';
      }
    });
    return success;
  }

  Future<bool> verifyLoginOTP() async {
    final code = codeController.text.trim();

    if (code.isEmpty) {
      errorMessage.value = 'Please enter the verification code';
      return false;
    }

    if (code.length != 6) {
      errorMessage.value = 'Please enter a valid 6-digit code';
      return false;
    }

    var success = false;
    await _withLoader(() async {
      try {
        final didVerify = await authenticationService.verifyLoginOTP(code);
        if (didVerify) {
          isLoggedIn.value = true;
          generatedCode.value = null;
          codeController.clear();
          errorMessage.value = '';
          success = true;
        } else {
          errorMessage.value = 'The verification code is incorrect.';
        }
      } on AuthenticationException catch (exception) {
        errorMessage.value = exception.message;
      } catch (_) {
        errorMessage.value = 'Verification failed. Please try again.';
      }
    });
    return success;
  }

  Future<bool> resendLoginOTP() async {
    var success = false;
    await _withLoader(() async {
      try {
        await authenticationService.resendLoginOTP();
        errorMessage.value = '';
        success = true;
      } on AuthenticationException catch (exception) {
        errorMessage.value = exception.message;
      } catch (_) {
        errorMessage.value = 'Failed to resend code. Please try again.';
      }
    });
    return success;
  }

  Future<bool> resendRegisterOTP() async {
    var success = false;
    await _withLoader(() async {
      try {
        await authenticationService.resendRegisterOTP();
        errorMessage.value = '';
        success = true;
      } on AuthenticationException catch (exception) {
        errorMessage.value = exception.message;
      } catch (_) {
        errorMessage.value = 'Failed to resend code. Please try again.';
      }
    });
    return success;
  }

  Future<void> logout() async {
    await authenticationService.logout();

    // Clear user-specific data in all persistent controllers
    if (Get.isRegistered<OwnerDashboardController>()) {
      Get.find<OwnerDashboardController>().clearUserData();
    }
    if (Get.isRegistered<OwnerBookingsController>()) {
      Get.find<OwnerBookingsController>().clearUserData();
    }
    if (Get.isRegistered<ChatController>()) {
      Get.find<ChatController>().clearUserData();
    }

    isLoggedIn.value = false;
    switchToLogin(clearPhone: true);
  }

  Future<void> _withLoader(Future<void> Function() action) async {
    if (isProcessing.value) {
      return;
    }

    isProcessing.value = true;
    try {
      await action();
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> _loadInitialState() async {
    final loggedIn = await authenticationService.isLoggedIn();
    isLoggedIn.value = loggedIn;

    final existingNumber = await authenticationService.registeredPhoneNumber();
    if (existingNumber != null) {
      phoneController.text = existingNumber;
    }
  }

  void resetFlow({bool clearPhone = false}) {
    errorMessage.value = '';
    generatedCode.value = null;
    codeController.clear();
    if (clearPhone) {
      phoneController.clear();
    }
  }
}
