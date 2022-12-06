class AppConstants {
  static const String APP_NAME = "DBFood";
  static const int APP_VERSION = 1;

  static const String BASE_URL =
      "http://mvs.bslmeiyu.com"; // mvs.bslmeiyu.com , 127.0.0.1:8000,  http://10.0.2.2:8000
  static const String POPULAR_PRODUCT_URI = "/api/v1/products/popular";
  static const String RECOMMENDED_PRODUCT_URI = "/api/v1/products/recommended";
  static const String DRINKS_URI = "/api/v1/products/drinks"; // 드링크 관련 서버 api
  static const String UPLOAD_URL = "/uploads/";

  //SignUp endpoint URI
  static const String REGSTRATION_URI = "/api/v1/auth/register"; // 디렉토리를 잘 기억해두자.. Larabel 에 등록해주어야 한다.
  static const String LOGIN_URI = "/api/v1/auth/login"; // 디렉토리를 잘 기억해두자.. Larabel 에 등록해주어야 한다.

  // userProfile 내용을 받아오기 위한 UII 정의부분
  static const String USER_INFO_URI = "/api/v1/customer/info";
  // 이부분은 반드시 Json 형태로 저장되어 있어야 하겠네.. 비록 String 으로 불러들이지만 나중에 JsonDecode 를 통해서 Json 형태로 만들어 줄 수 있으니..
  static const String USER_ADDRESS = 'user_address';
  static const String GEOCODE_URI = '/api/v1/config/geocode-api';
  // zone 에 관련된 api
  static const String ZONE_URI = '/api/v1/config/get-zone-id';
  static const String ADD_USER_ADDRESS = '/api/v1/customer/address/add';
  static const String ADDRESS_LIST_URI = '/api/v1/customer/address/list';

  // 서치 검색을 위한 api
  static const String SEARCH_LOCATION_URI = '/api/v1/config/place-api-autocomplete';
  static const String PLACE_DETAILS_URI = '/api/v1/config/place-api-detail';


  static const String TOKEN = ""; // 이제는 빈채로 있어야 되는거지..
  static const String PHONE = "";
  static const String PASSWORD = "";


  static const String CART_LIST = "cart-list";
  static const String CART_HISTORY_LIST = "cart-history-list";
}
