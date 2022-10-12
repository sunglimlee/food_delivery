import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/pages/home/food_page_body.dart';
import 'package:food_delivery/pages/home/food_page_header_bar.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:food_delivery/widget/icon_and_text.dart';
import 'package:food_delivery/widget/small_text.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({Key? key}) : super(key: key);

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  //double currPageValue = 0.0;
  int pagesTotalValue = 0;
  PagesValuesToShare pagesValuesToShare = PagesValuesToShare();

  // RenderBox was not laid out: RenderRepaintBoundary#4c015 NEEDS-LAYOUT NEEDS-PAINT 문제 해결에 좋은 예제.
  // Expanded 와 SingChildScrollView 는 한번에 묶어져 있어야 한다.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: Dimensions.height15, bottom: Dimensions.height15),
              // showing the header
              child: FoodPageHeaderBar(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // showing the body
                    Column(
                      children: [
                        FoodPageBody(
                          pagesValuesToShare: pagesValuesToShare,
                          callbackForCurrPageValue: update,
                        ),
                        dotIndicator(pagesValuesToShare.currPageValue),
                        SizedBox(
                          height: Dimensions.height30,
                        ),
                        _popularTextArea(),
                        SizedBox(
                          height: Dimensions.height30,
                        ),
                        _popularListView(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
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

  Widget _popularTextArea() {
    return Container(
      margin: EdgeInsets.only(left: Dimensions.edgeInsets30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          BigText(text: 'Popular'),
          SizedBox(
            width: Dimensions.edgeInsets10,
          ),
          Container(
            margin: EdgeInsets.only(bottom: Dimensions.edgeInsets3),
            child: BigText(
              text: '.',
              color: Colors.black26,
            ),
          ),
          SizedBox(
            width: Dimensions.edgeInsets10,
          ),
          Container(
            margin: EdgeInsets.only(bottom: Dimensions.edgeInsets2),
            child: SmallText(
              text: 'Food Paring',
            ),
          ),
        ],
      ),
    );
  }

  Widget _popularListView() {
    return SizedBox(
      //height: 700,
      child: ListView.builder(
          //scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(), // 이러니깐 스크롤이 안되게 하는구나.
          shrinkWrap: true,
          itemCount: 10, // 임시로 넣어놓은 값 TODO
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(
                  left: Dimensions.edgeInsets20,
                  right: Dimensions.edgeInsets20,
                  bottom: Dimensions.edgeInsets10),
              child: Row(
                children: [
                  // image section
                  Container(
                    width: Dimensions.listViewImgSize,
                    height: Dimensions.listViewImgSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: Colors.white38,
                      image: const DecorationImage(
                          image: NetworkImage(
                            'https://www.lacademie.com/wp-content/uploads/2021/06/kimchi-korea-800x600.jpg',
                          ),
                          fit: BoxFit.cover),
                    ),
                    child: Text('aa'),
                  ),
                  // text section
                  Expanded(
                    child: Container(
                      height: Dimensions.listViewTextContainerSize,
                      //width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(Dimensions.radius20),
                          bottomRight: Radius.circular(Dimensions.radius20),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: Dimensions.edgeInsets10,
                            right: Dimensions.edgeInsets10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BigText(
                              text: 'Nutritious fruit meal in China',
                            ),
                            SmallText(text: 'With chinese characteristics'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                IconAndText(
                                    iconData: Icons.circle_sharp,
                                    text: 'Normal',
                                    iconColor: AppColors.iconColor1),
                                IconAndText(
                                    iconData: Icons.location_on,
                                    text: '1.7km',
                                    iconColor: AppColors.mainColor),
                                IconAndText(
                                    iconData: Icons.circle_sharp,
                                    text: '32min',
                                    iconColor: AppColors.iconColor2),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

// 다른 하위 클래스에서 공용으로 사용하기 위한 클래스
class PagesValuesToShare {
  double currPageValue = 0.0;
  int pagesTotalValue = 3;
}
