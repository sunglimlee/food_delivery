import 'package:food_delivery/model/order_model.dart';
import 'package:food_delivery/pages/address/add_address_page.dart';
import 'package:food_delivery/pages/address/pic_address_map.dart';
import 'package:food_delivery/pages/auth/sign_in_page.dart';
import 'package:food_delivery/pages/cart/cart_page.dart';
import 'package:food_delivery/pages/food/popular_food_detail.dart';
import 'package:food_delivery/pages/food/recommended_food_detail.dart';
import 'package:food_delivery/pages/payment/order_success_page.dart';
import 'package:food_delivery/pages/payment/payment_page.dart';
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

  // payment 에 관련된 2가지 상수
  static const String payment = "/payment";
  static const String orderSuccess = '/order-successful';

  static String getSplashPage() => '$splashPage';

  static String getInitial() => '$initial';

  static String getPopularFood(int pageId, whichPage) =>
      '$popularFood?pageId=$pageId&whichPage=$whichPage'; // 이부분을 잘 봐라. 이렇게 넘기면 아주 쉽게 페이지 값을 넘길 수 있구나.
  static String getRecommendedFood(int pageId, whichPage) =>
      '$recommendedFood?pageId=$pageId&whichPage=$whichPage';

  static String getCartPage() => '$cartPage';

  static String get getSignInPage =>
      '$signIn'; // getCartPage() 와 똑같다. 그냥 get 을 이용해서 불러들이는거다.

  static String getAddAddressPage() => '$addAddress';

  static String getPickAddressMapPage() => '$pickAddressMap';

  static String getPaymentPage(String id, int userId) => '$payment?id=$id&userId=$userId'; // html 에 parameter 에 대문자를 사용해도 되나??? 되나보네.

  static String getOrderSuccessPage(String orderId, String status) => '$orderSuccess?id=$orderId&status=$status';

  static List<GetPage> routes = [
    GetPage(name: splashPage, page: () => const SplashScreen()),
    GetPage(
        name: initial,
        page: () => const HomePage(),
        transition: Transition.fadeIn),
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
    GetPage(
        name: signIn, page: () => SignInPage(), transition: Transition.fadeIn),
    GetPage(
        name: addAddress,
        page: () => AddAddressPage(),
        transition: Transition.fadeIn),
    GetPage(
        name: pickAddressMap,
        page: () {
          PickAddressMap pickAddressMap = Get.arguments; // 아규먼트는 그냥 통째로 넘기네..
          return pickAddressMap;
        },
        transition: Transition.fadeIn),
    // 잘기억하자. Get 에서 들어오는 파라미터를 이렇게 넘겨주고 있다.
    // 위에서 들어온 파라미터를 실제로 페이지를 전환할 때 어떻게 넘기는지 잘 기억하자.
    // 밑에 잘 봐라. Get.parameters['id'] 로 값을 받고 있다. 이거 너무 중요한 부분이다.
    GetPage(
        name: payment,
        page: () => PaymentPage(
            orderModel: OrderModel(
                id: int.parse(Get.parameters['id']!),
                userId: int.parse(Get.parameters['userId']!)))),
    GetPage(name: orderSuccess, page: () => OrderSuccessPage(
      orderId: Get.parameters['id']!, status: Get.parameters['status'].toString().contains("success")?1:0),
    ),
  ];
}
