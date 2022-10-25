import 'package:flutter/material.dart';
import 'package:food_delivery/controller/cart_controller.dart';
import 'package:food_delivery/controller/popular_product_controller.dart';
import 'package:food_delivery/pages/home/main_food_page.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/readmore_conversion.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/App_Column.dart';
import 'package:food_delivery/widget/app_icon.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:get/get.dart';

class PopularFoodDetail extends StatelessWidget {
  int pageId; // 라우터를 통해서 페이지 번호를 받아서
  PopularFoodDetail({required this.pageId, Key? key}) : super(key: key);

  // 정말 관건은 Positioned 을 사용하지 말자.
  @override
  Widget build(BuildContext context) {
    var product = Get.find<PopularProductController>()
        .popularProductList[pageId]; // product 를 받아서.
    print(
        "in popular_food_detail. value of pageid is ${pageId} and value of product is ${product}");
    Get.find<PopularProductController>().initProduct(
        product, Get.find<CartController>()); // 이거때메 무조건 0 으로 초기화한다.

    ReadMoreTextConversion readMoreTextConversion = ReadMoreTextConversion(
      Get.find<PopularProductController>()
          .popularProductList[pageId]
          .description!,
      trimLines: 3,
      colorClickableText: Colors.pink,
      trimMode: TrimModeC.Line,
      trimCollapsedText: 'Show more',
      trimExpandedText: 'Show less',
      style: TextStyle(
        height: 1.5,
        color: Colors.black45,
        fontSize: Dimensions.font20,
      ),
      moreStyle: TextStyle(
        color: Colors.red[300],
        fontSize: Dimensions.font16,
        fontWeight: FontWeight.bold,
      ),
      lessStyle: TextStyle(
        color: Colors.red[300],
        fontSize: Dimensions.font16,
        fontWeight: FontWeight.bold,
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            //Top Popular food detail image
            Container(
              margin: EdgeInsets.only(left: 0, right: 0),
              // 가로 세로를 반드시 정해주어야 하고.. 여기서는 height 에 맞춘다
              width: double.maxFinite,
              height: Dimensions.popularFoodImgSize,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(AppConstants.BASE_URL +
                          AppConstants.UPLOAD_URL +
                          Get.find<PopularProductController>()
                              .popularProductList[pageId]
                              .img!),
                      fit: BoxFit.cover)),
            ),
            // back & shopping cart icon button
            Container(
              margin: EdgeInsets.only(
                top: Dimensions.height45,
                left: Dimensions.edgeInsets20,
                right: Dimensions.edgeInsets20,
              ),
              //height: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.initial);
                      },
                      child: AppIcon(icon: Icons.arrow_back)), // 뒤로 가기 버턴
                  GetBuilder<PopularProductController>(
                    builder: (controller) {
                      return Stack(
                        children: [
                          AppIcon(icon: Icons.shopping_cart_outlined),
                          //전체 아이템 숫자가 shopping cart 아이콘 안 우측 상단에 나타나도록 한다.
                          Get.find<PopularProductController>().totalItems >= 1
                              ? const Positioned(
                                  right: 0,
                                  top: 0,
                                  child: AppIcon(
                                    icon: Icons.circle,
                                    size: 20,
                                    iconColor: Colors.transparent,
                                    backgroundColor: AppColors.mainColor,
                                  ))
                              : Container(),
                          Get.find<PopularProductController>().totalItems >= 1
                              ? Positioned(
                                  right: Get.find<PopularProductController>().totalItems < 9 ? 6 : 3,
                                  top: Get.find<PopularProductController>().totalItems < 9 ? 3 : 3,
                                  child: BigText(
                                    text:  Get.find<PopularProductController>().totalItems.toString(),
                                    size: Dimensions.font12,
                                    color: Colors.red[900],
                                  ))
                              : Container(),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
            // popular food description
            Container(
              margin: EdgeInsets.only(
                left: Dimensions.edgeInsets20,
                right: Dimensions.edgeInsets20,
                top: Dimensions.popularFoodImgSize - Dimensions.edgeInsets20,
              ),
              //height: 1500, // 높이?????
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppColumn(
                    title: Get.find<PopularProductController>()
                        .popularProductList[pageId]
                        .name!,
                  ),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: Dimensions.edgeInsets10),
                      child: BigText(
                        text: 'Introduce',
                      )),
                  InkWell(
                    onTap: () {},
                    child: readMoreTextConversion,
                  ),
                  SizedBox(
                    height: Dimensions.height45,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // 가로모드일 때 생각해봐라. 너무 크다. TODO
      // Shopping Cart 값의 변화에 대응하기 위해서 여기서도 GetBuilder 를 사용한다. 코드를 함축해서 잘랐다가 붙여넣기 하니깐 편하네..
      // 지금 헷갈리고 있다. 여기서 popularProduct 가 무엇이며 왜 사용하는지 갑자기 헷갈린다.
      // 왜냐면 애가 popularProduct 라고 하니깐 마치 하나인것 처럼 보이지만 GetBuilder 를 통해서 사실은 컨트롤러를 다루고 있다는 사실이다.
      // popularProduct 라고 썼지만 여전히 PopularProductController 이다.
      bottomNavigationBar:
          GetBuilder<PopularProductController>(builder: (popularProduct) {
        return Container(
          height: Dimensions.bottomeNavigationBarHeight,
          padding: EdgeInsets.only(
/*
              top: Dimensions.edgeInsets30,
              bottom: Dimensions.edgeInsets30,
*/
              left: Dimensions.edgeInsets20,
              right: Dimensions.edgeInsets20),
          decoration: BoxDecoration(
            color: Colors.grey[200], // Colors.pink,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimensions.radius20),
                topRight: Radius.circular(Dimensions.radius20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // Shopping Cart 에 수량을 입력하기 위한 작업. 근데 quantity 만 가지고 다루고 있다.
                //padding: EdgeInsets.all(Dimensions.edgeInsets20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    color: Colors.white),
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        popularProduct.setQuantity(false);
                      },
                      // 아이콘을 터치하는데 너무 작다.
                      // https://stackoverflow.com/questions/57114433/increase-tap-detection-area-of-a-widget
                      child: Container(
                        //color: Colors.green,
                        padding: EdgeInsets.only(
                          right: Dimensions.icon16,
                          left: Dimensions.icon16,
                          top: Dimensions.icon20,
                          bottom: Dimensions.icon20,
                        ),
                        child: Icon(
                          size: Dimensions.icon24,
                          Icons.remove,
                          color: AppColors.signColor,
                        ),
                        //color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.height10,
                    ),
                    BigText(
                      text: popularProduct.quantity.toString(),
                      color: Colors.black45,
                    ),
                    SizedBox(
                      width: Dimensions.height10,
                    ),
                    GestureDetector(
                      onTap: () {
                        popularProduct.setQuantity(true);
                      },
                      // 아이콘을 터치하는데 너무 작다.
                      // https://stackoverflow.com/questions/57114433/increase-tap-detection-area-of-a-widget
                      child: Container(
                        //color: Colors.green,
                        padding: EdgeInsets.only(
                          left: Dimensions.icon16,
                          right: Dimensions.icon16,
                          top: Dimensions.icon20,
                          bottom: Dimensions.icon20,
                        ),
                        child: Icon(
                          size: Dimensions.icon24,
                          Icons.add,
                          color: AppColors.signColor,
                        ),
                        //color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  popularProduct.addItem(Get.find<PopularProductController>()
                      .popularProductList[pageId]!);
                },
                child: Container(
                  padding: EdgeInsets.all(Dimensions.edgeInsets20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: Colors.green[200]),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BigText(
                        size: Dimensions.font16,
                        text: '\$' +
                            Get.find<PopularProductController>()
                                .popularProductList[pageId]
                                .price
                                .toString(),
                        color: Colors.black45,
                      ),
                      SizedBox(
                        width: Dimensions.height20,
                      ),
                      BigText(
                        text: 'Add to Cart',
                        color: Colors.black45,
                      ),
                    ],
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
