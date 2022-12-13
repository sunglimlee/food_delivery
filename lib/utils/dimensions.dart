import 'package:get/get.dart';

// 가로모드일 때 문제가 있는거 일단은 해결했다.
class Dimensions {
  // screensize
  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;

  // bigger Axis
  static double biggerAxis =
      screenHeight >= screenWidth ? screenHeight : screenWidth;
  static double smallerAxis =
      screenHeight >= screenWidth ? screenWidth : screenHeight;

  // Splash Screen Logo and characters
  static double splashLogo = biggerAxis / (844 / 300);
  static double splashCharacter = biggerAxis / (844 / 80);

  // for food_page_body mother container
  static double pageView = biggerAxis / 2.64;

  // for food_page_body
  static double pageViewContainer = biggerAxis / 3.84;

  // for food_page_body sub container
  static double pageViewTextContainer = biggerAxis / 7.03;

  // text sizes
  static double smallTextSize = biggerAxis / (844 / 14);
  static double bigTextSize = biggerAxis / (844 / 20);
  static double font12 = biggerAxis / (844 / 12);
  static double font16 = biggerAxis / (844 / 16);
  static double font20 = biggerAxis / (844 / 20);
  static double font26 = biggerAxis / (844 / 26);

  // dynamic height
  static double height5 = biggerAxis / (844 / 5);
  static double height10 = biggerAxis / 84.4;
  static double height15 = biggerAxis / 56.27;
  static double height20 = biggerAxis / 42.2;
  static double height30 = biggerAxis / (844 / 30);
  static double height45 = biggerAxis / (844 / 45);

  // dynamic width
  static double edgeInsets2 = biggerAxis / (844 / 2);
  static double edgeInsets3 = biggerAxis / (844 / 3);
  static double edgeInsets5 = biggerAxis / (844 / 5);
  static double edgeInsets10 = biggerAxis / 84.4;
  static double edgeInsets15 = biggerAxis / 56.27;
  static double edgeInsets20 = biggerAxis / 42.2;
  static double edgeInsets30 = biggerAxis / (844 / 30);
  static double edgeInsets45 = biggerAxis / (844 / 45);

  // radius
  static double radius5 = biggerAxis / (844 / 5);
  static double radius15 = biggerAxis / (844 / 15);
  static double radius20 = biggerAxis / (844 / 20);
  static double radius30 = biggerAxis / (844 / 30);

  // icon
  static double icon20 = biggerAxis / (844 / 20);
  static double icon24 = biggerAxis / (844 / 24);
  static double icon16 = biggerAxis / (844 / 16);

  // Popular List View Size
  static double listViewImgSize = smallerAxis / (390 / 120);
  static double listViewTextContainerSize = smallerAxis / (390 / 100);

  // Popular View Detail
  static double popularFoodImgSize = biggerAxis / (844 / 350);

  // bottomNavigationBar height
  static double bottomeNavigationBarHeight = biggerAxis / (844 / 95);

}

/*

import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/App_Column.dart';
import 'package:food_delivery/widget/app_icon.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:food_delivery/widget/icon_and_text.dart';
import 'package:food_delivery/widget/small_text.dart';

class PopularFoodDetail extends StatelessWidget {
  const PopularFoodDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: 1500,
            child: Stack(
              children: [
                //Top Popular food detail image
                Positioned(
                  left: 0, right: 0,
                  child: Container(
                    margin: EdgeInsets.only(left: 0, right: 0),
                    // 가로 세로를 반드시 정해주어야 하고.. 여기서는 height 에 맞춘다
                    width: double.maxFinite,
                    height: Dimensions.popularFoodImgSize  ,
                    decoration: const BoxDecoration(image: DecorationImage(image: NetworkImage('https://thumb.zumst.com/640x480/https://static.hubzum.zumst.com/hubzum/2020/04/03/09/b051210b4f8c462a91e03ee029e036a0.jpg'),
                      fit: BoxFit.cover  )),
                  ),
                ),
                // back & shopping cart icon button
                Positioned(
                  top: Dimensions.height45,
                  left: Dimensions.edgeInsets20,
                  right: Dimensions.edgeInsets20,
                  child: Container(
                    //height: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                      AppIcon(icon: Icons.arrow_back),
                      AppIcon(icon: Icons.shopping_cart_outlined)

                    ],

                ),
                  ),) ,
                // popular food description
                Positioned(
                    left: 0,
                    right: 0,
                    //bottom: 0, // 이렇게 해주니깐 밑에까지 채우는구나. 사실 바닥을 bottom 에 서 시작해라는거니깐..
                    top: Dimensions.popularFoodImgSize - Dimensions.edgeInsets20,
                    child: SizedBox(
                      height: 1500, // 높이?????
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppColumn(title: 'JJajang Sauce, Egg with Rice',),
                          SizedBox(height: Dimensions.height20,),
                          Padding(padding: EdgeInsets.only(left: Dimensions.edgeInsets20, right: Dimensions.edgeInsets20),
                          child: Container(
                              margin: EdgeInsets.only(bottom: Dimensions.edgeInsets20),
                              child: BigText(text: 'Introduce',))),
                          Expanded(
                            child: SingleChildScrollView(
                              child: ReadMoreText(
                                'Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.',
                                trimLines: 3,
                                colorClickableText: Colors.pink,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'Show more',
                                trimExpandedText: 'Show less',
                                style: TextStyle(color: Colors.black45,fontSize: Dimensions.font16, ),
                                moreStyle: TextStyle(color: Colors.red[300],fontSize: Dimensions.font16, fontWeight: FontWeight.bold, ),
                                lessStyle: TextStyle(color: Colors.red[300],fontSize: Dimensions.font16, fontWeight: FontWeight.bold, ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}



 */
