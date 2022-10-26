import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_delivery/controller/popular_product_controller.dart';
import 'package:food_delivery/controller/recommended_product_controller.dart';
import 'package:food_delivery/data/api/api_client.dart';
import 'package:food_delivery/data/repository/popular_product_repo.dart';
import 'package:food_delivery/data/repository/recommended_product_repo.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // 이미지에 애니메이션 효과를 준다. Splash Screen 만든다. 이 두개의 객체로 애니메이션이 만들어지는 걸 느껴보자.
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState(); // 항상 초기화해주고
    _loadResources();
    /*
      AnyClass() { newObject() { return something;}}
      var x = anyClass();, x = x.newObject(); 이렇게 하는게 정상인데 더 짧은 방법이
      var x = anyClass()..newObject(); // 이렇게 하면 더 짧게 작업할 수 있다.
     */
    //vsync 가 실제로 이 에니메이션의 실행을 관장하도록 하는거다.
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward(); // .. 의 뜻은 animationController.forward() 라는 뜻임.
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.linear);
    // 이제 에니메이션이 끝나고 나면 좀 기다렸다가 다음페이지로 넘어가도록 한다.
    Timer(
        const Duration(seconds: 3),
        () => Get.offNamed(
            RouteHelper.getInitial())); // 이걸 하려면 라우터에 splash 페이지를 세팅을 해야한다.
  }

  Future<void> _loadResources() async {
    // 인터넷에서 데이터를 불러들이는 부분이다. 리스트에서 데이터가 없어진게 아니므로 여기 계속 살아있지.. 그런데 스플래쉬 스크린이 없어지면 이것도 없어지지 않나? permanent 로 해줘야 할 것 같은데..
/*
      //일단 안한다.
     Get.find<PopularProductController>().getPopularProductList();
     Get.find<RecommendedProductController>().getRecommendedProductList();
*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
              scale: animation,
              child: Center(
                  child: Image.asset(
                'assets/images/Food_Delivery_Splash_Logo-1.png',
                width: Dimensions.splashLogo,
              ))), // 나중에 조절해야한다
          Center(
              child: Image.asset(
            'assets/images/best food logo.png',
            height: Dimensions.splashCharacter,
          )),
        ],
      ),
    );
  }
}
