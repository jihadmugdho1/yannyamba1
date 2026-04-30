import 'package:yannyamba/core/core.dart';

class AuthenticationService {
  Future<bool> isLoggedIn() async {
    return StorageService.getAuthLoggedIn();
  }

  Future<String?> registeredPhoneNumber() async {
    return StorageService.getAuthRegisteredPhone();
  }

  Future<void> logout() async {
    // Clear all stored data
    await StorageService.clearAll();
  }

  Future<String> requestVerificationCode(String phoneNumber) async {
    final sanitizedNumber = phoneNumber.trim();

    try {
      final networkCaller = NetworkCaller();
      final response = await networkCaller.postRequest(
        ApiConstants.register,
        body: {'phone': sanitizedNumber},
      );

      if (!response.isSuccess) {
        throw AuthenticationException(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to send verification code',
        );
      }

      // Store the pending phone number
      await StorageService.setAuthPendingPhone(sanitizedNumber);
      await StorageService.setAuthLoggedIn(false);

      // Return a placeholder code (actual code is sent via SMS)
      // The code will be entered by the user from the SMS they receive
      return 'Code sent to $sanitizedNumber';
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw AuthenticationException(
        'Failed to send verification code: ${e.toString()}',
      );
    }
  }

  Future<bool> verifyCode(String code) async {
    final pendingPhone = await StorageService.getAuthPendingPhone();

    if (pendingPhone == null || code.isEmpty) {
      return false;
    }

    try {
      final networkCaller = NetworkCaller();
      final response = await networkCaller.postRequest(
        ApiConstants.verifyOTP,
        body: {'phone': pendingPhone, 'otp': code.trim()},
      );

      if (response.statusCode != 200) {
        throw AuthenticationException(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'OTP verification failed',
        );
      }

      final respData = response.responseData;
      final data = respData is Map ? respData['data'] : null;
      final accessToken = data is Map ? data['accessToken'] as String? : null;
      final userId = data is Map && data['user'] is Map
          ? data['user']['_id'] as String?
          : null;

      if (accessToken == null || userId == null) {
        throw const AuthenticationException('Invalid server response');
      }

      // Save token and update login state
      await StorageService.saveToken(accessToken, userId);
      await StorageService.setAuthRegisteredPhone(pendingPhone);
      await StorageService.setAuthPendingPhone(null);
      await StorageService.setAuthLoggedIn(true);

      return true;
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw AuthenticationException('Verification failed: ${e.toString()}');
    }
  }

  Future<String> login(String phoneNumber) async {
    final sanitizedNumber = phoneNumber.trim();
    try {
      final networkCaller = NetworkCaller();
      final response = await networkCaller.postRequest(
        ApiConstants.login,
        body: {'phone': sanitizedNumber},
      );

      if (!response.isSuccess) {
        throw AuthenticationException(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to send verification code',
        );
      }

      // Store the pending phone number for login
      await StorageService.setAuthPendingPhone(sanitizedNumber);
      await StorageService.setAuthLoggedIn(false);

      // Return a placeholder message (actual OTP is sent via SMS)
      return 'Code sent to $sanitizedNumber';
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw AuthenticationException(
        'Failed to send verification code: ${e.toString()}',
      );
    }
  }

  Future<bool> verifyLoginOTP(String code) async {
    final pendingPhone = await StorageService.getAuthPendingPhone();

    if (pendingPhone == null || code.isEmpty) {
      return false;
    }

    try {
      final networkCaller = NetworkCaller();
      final response = await networkCaller.postRequest(
        ApiConstants.verifyOTPLogin,
        body: {'phone': pendingPhone, 'otp': code.trim()},
      );

      if (response.statusCode != 200) {
        throw AuthenticationException(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'OTP verification failed',
        );
      }

      final respData = response.responseData;
      final data = respData is Map ? respData['data'] : null;
      final accessToken = data is Map ? data['accessToken'] as String? : null;
      final userId = data is Map && data['user'] is Map
          ? data['user']['_id'] as String?
          : null;

      if (accessToken == null || userId == null) {
        throw const AuthenticationException('Invalid server response');
      }

      // Save token and update login state
      await StorageService.saveToken(accessToken, userId);
      await StorageService.setAuthRegisteredPhone(pendingPhone);
      await StorageService.setAuthPendingPhone(null);
      await StorageService.setAuthLoggedIn(true);

      return true;
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw AuthenticationException('Verification failed: ${e.toString()}');
    }
  }

  Future<String> resendLoginOTP() async {
    final pendingPhone = await StorageService.getAuthPendingPhone();

    if (pendingPhone == null || pendingPhone.isEmpty) {
      throw const AuthenticationException('Phone number not found');
    }

    try {
      final networkCaller = NetworkCaller();
      final response = await networkCaller.postRequest(
        ApiConstants.resendLoginOTP,
        body: {'phone': pendingPhone},
      );

      if (!response.isSuccess) {
        throw AuthenticationException(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to resend verification code',
        );
      }

      return 'Code resent to $pendingPhone';
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw AuthenticationException(
        'Failed to resend verification code: ${e.toString()}',
      );
    }
  }

  Future<String> resendRegisterOTP() async {
    final pendingPhone = await StorageService.getAuthPendingPhone();

    if (pendingPhone == null || pendingPhone.isEmpty) {
      throw const AuthenticationException('Phone number not found');
    }

    try {
      final networkCaller = NetworkCaller();
      final response = await networkCaller.postRequest(
        ApiConstants.resendOTP,
        body: {'phone': pendingPhone},
      );

      if (!response.isSuccess) {
        throw AuthenticationException(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to resend verification code',
        );
      }

      return 'Code resent to $pendingPhone';
    } catch (e) {
      if (e is AuthenticationException) rethrow;
      throw AuthenticationException(
        'Failed to resend verification code: ${e.toString()}',
      );
    }
  }

  Future<bool> shouldRedirectToOwnersDashboard() async {
    return StorageService.getRedirectToOwnersDashboard();
  }

  Future<void> clearRedirectToOwnersDashboard() async {
    await StorageService.clearRedirectToOwnersDashboard();
  }
}

class AuthenticationException implements Exception {
  const AuthenticationException(this.message);

  final String message;

  @override
  String toString() => message;
}
