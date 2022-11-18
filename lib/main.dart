import 'package:flutter/material.dart';
import 'package:food_delivery/controller/cart_controller.dart';
import 'package:food_delivery/controller/popular_product_controller.dart';
import 'package:food_delivery/controller/recommended_product_controller.dart';
import 'package:food_delivery/pages/auth/sign_up_page.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:get/get.dart';

import 'helper/dependencies.dart' as dep;
import 'pages/auth/sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 꼭 바인딩이 완료되었는지 확인한후 진해한다.
  await dep.init(); // 여기 맨처음에 dependencies 를 설정해 준다.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /*
    일단 왜 내가 여기에 PopularProductController & RecommendedProductController 의 find 를 여기에 해놨는지 생각해보자. Splash Screen 이 맨처음 initialRoute 로 실행될 때 이미
    GetMaterialApp 의 initialRoute 에서 실행되므로 이때 벌써 put 이나 layPut 에 관계없이 Dependency 가 생성된다는거지.. 그리고 그게 계속 살아있게 된다는거지..
    dbesTech 가 비디오에서 Splash 페이지에다가 이 내용을 넣었는데 그건 벌써 의미가 없지... 이미 GetMaterialApp 안에서 Splash Screen 이 돌아가므로....
     */
    Get.find<CartController>().getCartData(); // 기존의 구입목록을 카트에 넣어서 보여준다. 이걸로 무지하게 헤맸다...
    Get.find<PopularProductController>()
        .getPopularProductList(); // 왜 find 했는데 먹히냐고? 알다시피 dep 에다가 모든걸 만들어 놓고 lazyput 으로 해놓았기 때문이지..
    Get.find<RecommendedProductController>().getRecommendedProductList();
    // SharedPreferences 의 값을 불러들이기 위해서 CartController 를 사용한다.
    return GetMaterialApp(
      initialRoute: RouteHelper.getSplashPage(), // 원래 이거다.

      // 이곳이 홈페이지, getPages 때문에 home: 을 넣어줄 필요가 없다. 스플래쉬 스크린에서 2초후 다음으로 넘어간다.
      getPages: RouteHelper.routes,
      debugShowCheckedModeBanner: false,
      title: 'Food Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const SplashScreen(),
      //home: const RecommendedFoodDetail(),
      //home: TestModel(),
      //home: SignInPage(),
    );
  }
}
