import 'package:food_delivery/pages/address/add_address_page.dart';
import 'package:food_delivery/pages/address/pic_address_map.dart';
import 'package:food_delivery/pages/auth/sign_in_page.dart';
import 'package:food_delivery/pages/cart/cart_page.dart';
import 'package:food_delivery/pages/food/popular_food_detail.dart';
import 'package:food_delivery/pages/food/recommended_food_detail.dart';
import 'package:food_delivery/pages/splash/splash_page.dart';
import 'package:food_delivery/widget/home_page.dart';
import 'package:get/get.dart';

class RouteHelper {
  // 그냥 이름을 정의한 것일 뿐이다. 마치 디렉토리를 정해놓은 것 처럼.. 이렇게 했기 때문에 html 의 파라미터를 넣는것처럼 하는게 가능하다.
  static const String splashPage = "/splash-page";
  static const String initial = "/"; // 이곳이 홈페이지이다.
  static const String popularFood = "/popular-food";
  static const String recommendedFood = "/recommended-food";
  static const String cartPage = "/cart-page";
  static const String signIn = "/sign-in";

  static const String addAddress = "/add-address";
  static const String pickAddressMap = "/pick-address";

  static String getSplashPage() => '$splashPage';

  static String getInitial() => '$initial';

  static String getPopularFood(int pageId, whichPage) =>
      '$popularFood?pageId=$pageId&whichPage=$whichPage'; // 이부분을 잘 봐라. 이렇게 넘기면 아주 쉽게 페이지 값을 넘길 수 있구나.
  static String getRecommendedFood(int pageId, whichPage) =>
      '$recommendedFood?pageId=$pageId&whichPage=$whichPage';

  static String getCartPage() => '$cartPage';
  static String get getSignInPage => '$signIn'; // getCartPage() 와 똑같다. 그냥 get 을 이용해서 불러들이는거다.

  static String getAddAddressPage() => '$addAddress';
  static String getPickAddressMapPage() => '$pickAddressMap';

  static List<GetPage> routes = [
    GetPage(name: splashPage, page: () => const SplashScreen()),
    GetPage(name: initial, page: () => const HomePage(), transition: Transition.fadeIn),
    GetPage(
      name: popularFood,
      // 맞네.. popularFood 로 들어오면 무조건 페이지 아이디 있다는거지. 함수로 전달하니깐.
      page: () {
        // 그래서 이게 무조건 실행되는구나.
        int pageId = int.parse(Get.parameters[
            'pageId']!); // 여기를 잘봐라.. 결정적인 곳이다. 파라미터값을 여기서 파싱하고 있다. 그리고는 PopularFoodDetail 로 넘겨주겠지
        String whichPage = Get.parameters['whichPage'].toString();
        print("in route_helper. whichPage value is ${whichPage}");
        return PopularFoodDetail(pageId: pageId, whichPage: whichPage);
      },
      transition: Transition.circularReveal,
    ),
    GetPage(
      name: recommendedFood,
      page: () {
        int pageId = int.parse(Get.parameters['pageId']!);
        String whichPage = Get.parameters['whichPage'].toString();
        return RecommendedFoodDetail(pageId: pageId, whichPage: whichPage);
      },
      transition: Transition.circularReveal,
    ),
    GetPage(
        name: cartPage,
        page: () => const CartPage(),
        transition: Transition.fadeIn),
    GetPage(name: signIn, page: () => SignInPage(), transition: Transition.fadeIn),
    GetPage(name: addAddress, page: () => AddAddressPage(), transition: Transition.fadeIn),
    GetPage(name: pickAddressMap, page: () {
      PickAddressMap pickAddressMap = Get.arguments; // 아규먼트는 그냥 통째로 넘기네..
      return pickAddressMap;
    }, transition: Transition.fadeIn),
  ];
}
