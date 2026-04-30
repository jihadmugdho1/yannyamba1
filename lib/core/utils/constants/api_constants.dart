class ApiConstants {
  // static const String baseUrl =
  // "https://room-rent-service-backend-production.up.railway.app/api";

  static const String baseUrl = "http://46.224.80.189:5000/api";

  //Auth Endpoints
  static const String login = "$baseUrl/auth/login";
  static const String verifyOTPLogin = "$baseUrl/auth/verify-login-otp";
  static const String resendLoginOTP = "$baseUrl/auth/resend-login-otp";

  //
  static const String register = "$baseUrl/auth/register";
  static const String verifyOTP = "$baseUrl/auth/verify-register-otp";
  static const String resendOTP = "$baseUrl/auth/resend-register-otp";

  //User profile Endpoints
  static const String getProfile = "$baseUrl/user/get-myself-profile";
  static const String updateProfile = "$baseUrl/user/update-profile";

  //Apartments Endpoints
  static const String getFurnishedApartments =
      "$baseUrl/product/get-all?listing_type=Furnished Apartment";

  static const String getNormalApartments =
      "$baseUrl/product/get-all?listing_type=Normal Apartment";

  //Post Apartment Endpoints
  static const String postProperty = "$baseUrl/product";

  //Owner Dashboard Endpoints
  static const String getOwnerNormalProperties =
      "$baseUrl/product/get-myself-product?listing_type=Normal Apartment";
  static const String getOwnerFurnishedProperties =
      "$baseUrl/product/get-myself-product?listing_type=Furnished Apartment";

  static const String getOwnerStats = "$baseUrl/product/get-stat";

  static const String addBookingDates =
      "$baseUrl/product/add-booking-date/{propertyId}";

  // Increment view count endpoint
  static const String incrementApartmentViewCount =
      "$baseUrl/product/add-viewed-product/{apartmentId}";

  static const String incrementQueryCount =
      "$baseUrl/product/add-query-product/{apartmentId}";

  //Booking Endpoints
  static const String getOwnerBookings = "$baseUrl/booking/owner-bookings";
  static const String getApartmentBookings =
      "$baseUrl/booking/apartment/{apartmentId}";
  static const String createBooking = "$baseUrl/booking";

  //Favorites Endpoints
  static const String addToFavorites =
      "$baseUrl/product/add-fevourite-apartment";
  static const String deleteFromFavorites =
      "$baseUrl/product/delete-fevourite-apartment";
  static const String getFavorites =
      "$baseUrl/product/myself-fevourite-apartment";

  //Get Amenities and Features Endpoints
  static const String getCities = "$baseUrl/city";
  static const String getNeighborhoods = "$baseUrl/neiborhood";
  static const String getHouseRules = "$baseUrl/house-rules";
  static const String getAmenities = "$baseUrl/building-amenities";
  static const String getWhatsIncluded = "$baseUrl/whats-include";
  static const String getPropertyFeatures = "$baseUrl/property-feature";
  static const String getNormalApartmentToggle =
      "$baseUrl/product/show-normal-apartment";
}
