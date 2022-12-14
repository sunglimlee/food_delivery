import 'package:food_delivery/controller/auth_controller.dart';
import 'package:food_delivery/controller/cart_controller.dart';
import 'package:food_delivery/controller/location_controller.dart';
import 'package:food_delivery/controller/order_controller.dart';
import 'package:food_delivery/controller/popular_product_controller.dart';
import 'package:food_delivery/controller/recommended_product_controller.dart';
import 'package:food_delivery/controller/user_controller.dart';
import 'package:food_delivery/data/api/api_client.dart';
import 'package:food_delivery/data/repository/auth_repo.dart';
import 'package:food_delivery/data/repository/cart_repo.dart';
import 'package:food_delivery/data/repository/location_repo.dart';
import 'package:food_delivery/data/repository/order_repo.dart';
import 'package:food_delivery/data/repository/popular_product_repo.dart';
import 'package:food_delivery/data/repository/recommended_product_repo.dart';
import 'package:food_delivery/data/repository/user_repo.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 이렇게 그냥 함수만 설정하고 나중에 사용하는 부분에서 as Dep 라고 하고 Dep.init() 라고 해도 되는구나.
// 만약에 클래스로 정의했다면 클래스 생성과 여러가지 클래스에 관련된 부분들을 다루어 주어야 하는데 이건 그럴 필요가 없고 그냥 함수로 간단하게 초기화하고
// 이런부분들을 실행시켜 주는걸로 끝내는 거지.
Future<void> init() async {
  final shardPreferences = await SharedPreferences.getInstance();

  Get.lazyPut(() => shardPreferences); // 이건 여러군데서 사용하려고 이렇게 넎는거잖아..
  // api client, 잘봐라 GetService 이기 때문에 계속 살아있다.
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants
          .BASE_URL, sharedPreferences: Get.find())); // http://127.0.0.1:8000 // mvs.bslmeiyu.com // http://localhost:8000

  // repository
  // 기억하자. Get.find<ApiClient>() 로 찾는다는것..
  // 이것도 계속 살아 있다.
  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => RecommendedProductRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => CartRepo(shardPreferences));
  // signup 하기 위한 AuthRepo Dependency injection 부분
  Get.lazyPut(() => AuthRepo(Get.find<ApiClient>(), Get.find<SharedPreferences>()));
  // UserProfile 데이터를 업데이트 하기 위한 Dependency injection 부분
  Get.lazyPut(() => UserRepo(apiClient: Get.find<ApiClient>()));
  // Google Map 을 위한 Repository Dependency Injection 부분
  Get.lazyPut(() => LocationRepo(apiClient: Get.find<ApiClient>(), sharedPreferences: Get.find<SharedPreferences>()));
  // payment 에 관련된 부분
  Get.lazyPut(() => OrderRepo(apiClient: Get.find<ApiClient>()));
  // controller 제일 중요한거잖아. 그리고 이 dependencies 를 main.dart 에서 사용하니깐 이페이지가 다른 페이지를 다 품고 있으니깐 굳이 이걸 permanent 로 해줄 필요가 없는거지..
  // 이부분이 헷갈리면 main.dart 의 Get.find 부분을 봐라. 명확히 이해가 된다. Splash Screen 이 없어지면 그 안에 적용했던 dependency 도 없어지니 화면에는 보였지만 detail 페이지로 넘어갈 때는 dependency 를 찾을 수 가 없게 되는 거지..
/*
  Get.put<PopularProductController>(PopularProductController(popularProductRepo: PopularProductRepo(apiClient: Get.find<ApiClient>())),);
  Get.put<RecommendedProductController>(RecommendedProductController(recommendedProductRepo: RecommendedProductRepo(apiClient: Get.find<ApiClient>())),);
*/

  Get.lazyPut(() => PopularProductController(
      popularProductRepo: Get.find<PopularProductRepo>()));
  Get.lazyPut(() => RecommendedProductController(
      recommendedProductRepo: Get.find<RecommendedProductRepo>()));
  Get.lazyPut(() => CartController(cartRepo: Get.find<CartRepo>()));
  // Signup 하기 위한 AuthController Dependency injection 부분
  Get.lazyPut(() => AuthController(Get.find<AuthRepo>()));
  // UserProfile 데이터를 업데이트 하기 위한 Controller 부분
  Get.lazyPut(() => UserController(Get.find<UserRepo>()));
  // Google Map 을 위한 Controller Dependency Injection 부분
  Get.lazyPut(() => LocationController(locationRepo: Get.find<LocationRepo>()));
  Get.lazyPut(() =>OrderController(orderRepo: Get.find<OrderRepo>()));
}
