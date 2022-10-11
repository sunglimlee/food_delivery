import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/home/food_page_body.dart';
import 'package:food_delivery/home/food_page_header_bar.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({Key? key}) : super(key: key);

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  //double currPageValue = 0.0;
  int pagesTotalValue = 0;
  PagesValuesToShare pagesValuesToShare = PagesValuesToShare();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: Dimensions.height15, bottom: Dimensions.height15),
                child: Column(
                  children: [
                    // showing the header
                    const FoodPageHeaderBar(),
                    // showing the body
                    FoodPageBody(
                      pagesValuesToShare: pagesValuesToShare,
                      callbackForCurrPageValue: update,
                    ),
                  ],
                ),
              ),
              dotIndicator(pagesValuesToShare.currPageValue),
            ],
          ),
        ),
      ),
    );
  }

  void update() {
    setState(() {
      // 옮길때마다 setState 를 해주어야 indicator 가 바뀐다.
      // pagesValuesToShare.currPageValue = currentPageValue);
    });
  }

  Widget dotIndicator(double currIndexPage) {
    return DotsIndicator(
      dotsCount: pagesValuesToShare.pagesTotalValue,
      position: currIndexPage,
      decorator: DotsDecorator(
        activeColor: AppColors.mainColor,
        size: Size.square(Dimensions.height10),
        activeSize: Size(Dimensions.height20, Dimensions.height10),
        activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius5)),
      ),
    );
  }
}

// 다른 하위 클래스에서 공용으로 사용하기 위한 클래스
class PagesValuesToShare {
  double currPageValue = 0.0;
  int pagesTotalValue = 3;
}
