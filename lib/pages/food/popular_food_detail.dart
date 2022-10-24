import 'package:flutter/material.dart';
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
  PopularFoodDetail({ required this.pageId, Key? key}) : super(key: key);

  // 정말 관건은 Positioned 을 사용하지 말자.
  @override
  Widget build(BuildContext context) {


    ReadMoreTextConversion readMoreTextConversion = ReadMoreTextConversion(
      Get.find<PopularProductController>().popularProductList[pageId].description!,
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
                          Get.find<PopularProductController>().popularProductList[pageId].img!),
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
                  AppIcon(icon: Icons.shopping_cart_outlined)
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
                    title: Get.find<PopularProductController>().popularProductList[pageId].name!,
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
                    onTap: () {
                    },
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
      bottomNavigationBar: Container(
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
              padding: EdgeInsets.all(Dimensions.edgeInsets20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.remove,
                    color: AppColors.signColor,
                  ),
                  SizedBox(
                    width: Dimensions.height10,
                  ),
                  BigText(
                    text: '0',
                    color: Colors.black45,
                  ),
                  SizedBox(
                    width: Dimensions.height10,
                  ),
                  const Icon(
                    Icons.add,
                    color: AppColors.signColor,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(Dimensions.edgeInsets20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.green[200]),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BigText(
                    size: Dimensions.font16,
                    text: '\$' + Get.find<PopularProductController>().popularProductList[pageId].price.toString(),
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
          ],
        ),
      ),
    );
  }
}
