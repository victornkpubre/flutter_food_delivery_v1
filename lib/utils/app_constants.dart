class AppConstants {
  static const String APP_NAME = "DBFood";
  static const int APP_VERSION = 1;

  //production base url: static const String BASE_URL = "https://fingerfoodapplications.com/portfolios/a007/food_delivery_api";
  // local base url: static const String BASE_URL = "https://jrj6k4pcny.sharedwithexpose.com";
  static const String BASE_URL = "https://olmflc9z9g.sharedwithexpose.com";
  static const String POPULAR_PRODUCT_URI = "/api/v1/products/popular";
  static const String RECOMMENDED_PRODUCT_URI = "/api/v1/products/recommended";
  static const String UPLOADS_URL = "/uploads/";

  //Auth Constants
  static const String TOKEN = "DBtoken";
  static const String SIGNIN_URI = "/api/v1/auth/login";
  static const String REGISTRATION_URI = "/api/v1/auth/register";
  static const String USER_INFO = "/api/v1/customer/info";

  static const String CART_LIST = "cart-list";
  static const String CART_HISTORY_LIST = "cart-history-list";

  static const String PHONE = "";
  static const String PASSWORD = "";

  static String USER_ADDRESS = 'User Address';
  static const String ADD_USER_ADDRESS="/api/v1/customer/address/add";
  static const String ADDRESS_LIST_URI="/api/v1/customer/address/list";
  static const String GEOCODE_URI = '/api/v1/config/geocode-api';
  static const String ZONE_URI = '/api/v1/config/get-zone-id';
  static const String SEARCH_LOCATION_URI = '/api/v1/config/place-api-autocomplete';
  static const String PLACE_DETAILS_URI = '/api/v1/config/place-api-details';

  //Delete before upload
  
  //static const String googleApi = "AIzaSyCTDccYi2gQ7vfM5GLCxS8NJ_THP-yy-50";
  static const String googleApi = "AIzaSyAaQoscj0R7bBHkMGtGctaLT2-fxQINFpw";
  
}
