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

  static const String TOKEN = ""; // 이제는 빈채로 있어야 되는거지..
  static const String PHONE = "";
  static const String PASSWORD = "";


  static const String CART_LIST = "cart-list";
  static const String CART_HISTORY_LIST = "cart-history-list";
}
