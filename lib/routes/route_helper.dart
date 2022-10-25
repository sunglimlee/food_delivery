import 'package:food_delivery/pages/food/popular_food_detail.dart';
import 'package:food_delivery/pages/food/recommended_food_detail.dart';
import 'package:food_delivery/pages/home/main_food_page.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String initial = "/"; // 이곳이 홈페이지이다.
  static const String popularFood = "/popular-food";
  static const String recommendedFood = "/recommended-food";

  static String getInitial() => '$initial';

  static String getPopularFood(int pageId) =>
      '$popularFood?pageId=$pageId'; // 이부분을 잘 봐라. 이렇게 넘기면 아주 쉽게 페이지 값을 넘길 수 있구나.
  static String getRecommendedFood(int pageId) =>
      '$recommendedFood?pageId=$pageId';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const MainFoodPage()),
    GetPage(
      name: popularFood,
      // 맞네.. popularFood 로 들어오면 무조건 페이지 아이디 있다는거지. 함수로 전달하니깐.
      page: () {
        // 그래서 이게 무조건 실행되는구나.
        int pageId = int.parse(Get.parameters[
            'pageId']!); // 여기를 잘봐라.. 결정적인 곳이다. 파라미터값을 여기서 파싱하고 있다. 그리고는 PopularFoodDetail 로 넘겨주겠지
        return PopularFoodDetail(pageId: pageId!);
      },
      transition: Transition.circularReveal,
    ),
    GetPage(
      name: recommendedFood,
      page: () {
        int pageId = int.parse(Get.parameters['pageId']!);
        return RecommendedFoodDetail(pageId: pageId!);
      },
      transition: Transition.circularReveal,
    ),
  ];
}