import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Constants for preference keys
  static const String _tokenKey = 'token';
  static const String _idKey = 'userId';

  static const String _authLoggedInKey = 'auth.logged_in';
  static const String _authRegisteredPhoneKey = 'auth.registered_phone';
  static const String _authPendingPhoneKey = 'auth.pending_phone';
  static const String _authVerificationCodeKey = 'auth.verification_code';
  static const String _redirectToOwnersDashboardKey = 'auth.redirect_to_owners';

  // Singleton instance for SharedPreferences
  static SharedPreferences? _preferences;

  static Future<void> _ensureInitialized() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  // Initialize SharedPreferences (call this during app startup)
  static Future<void> init() async {
    await _ensureInitialized();
  }

  // Check if a token exists in local storage
  static Future<bool> hasToken() async {
    await _ensureInitialized();
    final token = _preferences?.getString(_tokenKey);
    return token != null;
  }

  // Save the token and user ID to local storage
  static Future<void> saveToken(String token, String id) async {
    await _ensureInitialized();
    await _preferences?.setString(_tokenKey, token);
    await _preferences?.setString(_idKey, id);
  }

  // Remove the token and user ID from local storage (for logout)
  static Future<void> logoutUser() async {
    await _ensureInitialized();
    await _preferences?.remove(_tokenKey);
    await _preferences?.remove(_idKey);
  }

  // Getter for user ID
  static Future<String?> getUserId() async {
    await _ensureInitialized();
    return _preferences?.getString(_idKey);
  }

  // Getter for token
  static Future<String?> getToken() async {
    await _ensureInitialized();
    return _preferences?.getString(_tokenKey);
  }

  // Authentication helpers
  static Future<void> setAuthLoggedIn(bool value) async {
    await _ensureInitialized();
    await _preferences?.setBool(_authLoggedInKey, value);
  }

  static Future<bool> getAuthLoggedIn() async {
    await _ensureInitialized();
    return _preferences?.getBool(_authLoggedInKey) ?? false;
  }

  static Future<void> setAuthRegisteredPhone(String phoneNumber) async {
    await _ensureInitialized();
    await _preferences?.setString(_authRegisteredPhoneKey, phoneNumber);
  }

  static Future<String?> getAuthRegisteredPhone() async {
    await _ensureInitialized();
    return _preferences?.getString(_authRegisteredPhoneKey);
  }

  static Future<void> setAuthPendingPhone(String? phoneNumber) async {
    await _ensureInitialized();
    if (phoneNumber == null) {
      await _preferences?.remove(_authPendingPhoneKey);
    } else {
      await _preferences?.setString(_authPendingPhoneKey, phoneNumber);
    }
  }

  static Future<String?> getAuthPendingPhone() async {
    await _ensureInitialized();
    return _preferences?.getString(_authPendingPhoneKey);
  }

  static Future<void> setAuthVerificationCode(String? code) async {
    await _ensureInitialized();
    if (code == null) {
      await _preferences?.remove(_authVerificationCodeKey);
    } else {
      await _preferences?.setString(_authVerificationCodeKey, code);
    }
  }

  static Future<String?> getAuthVerificationCode() async {
    await _ensureInitialized();
    return _preferences?.getString(_authVerificationCodeKey);
  }

  // Redirect to owners dashboard after login
  static Future<void> setRedirectToOwnersDashboard(bool value) async {
    await _ensureInitialized();
    await _preferences?.setBool(_redirectToOwnersDashboardKey, value);
  }

  static Future<bool> getRedirectToOwnersDashboard() async {
    await _ensureInitialized();
    return _preferences?.getBool(_redirectToOwnersDashboardKey) ?? false;
  }

  static Future<void> clearRedirectToOwnersDashboard() async {
    await _ensureInitialized();
    await _preferences?.remove(_redirectToOwnersDashboardKey);
  }

  // Clear all stored data (for complete logout)
  static Future<void> clearAll() async {
    await _ensureInitialized();
    await _preferences?.clear();
  }
}
