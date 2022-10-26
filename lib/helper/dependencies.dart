import 'package:food_delivery/controller/cart_controller.dart';
import 'package:food_delivery/controller/popular_product_controller.dart';
import 'package:food_delivery/controller/recommended_product_controller.dart';
import 'package:food_delivery/data/api/api_client.dart';
import 'package:food_delivery/data/repository/cart_repo.dart';
import 'package:food_delivery/data/repository/popular_product_repo.dart';
import 'package:food_delivery/data/repository/recommended_product_repo.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:get/get.dart';

// 이렇게 그냥 함수만 설정하고 나중에 사용하는 부분에서 as Dep 라고 하고 Dep.init() 라고 해도 되는구나.
// 만약에 클래스로 정의했다면 클래스 생성과 여러가지 클래스에 관련된 부분들을 다루어 주어야 하는데 이건 그럴 필요가 없고 그냥 함수로 간단하게 초기화하고
// 이런부분들을 실행시켜 주는걸로 끝내는 거지.
Future<void> init() async {
  // api client, 잘봐라 GetService 이기 때문에 계속 살아있다.
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants
          .BASE_URL)); // http://127.0.0.1:8000 // mvs.bslmeiyu.com // http://localhost:8000

  // repository
  // 기억하자. Get.find<ApiClient>() 로 찾는다는것..
  // 이것도 계속 살아 있다.
  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => RecommendedProductRepo(apiClient: Get.find<ApiClient>()));
  Get.lazyPut(() => CartRepo());

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
}
