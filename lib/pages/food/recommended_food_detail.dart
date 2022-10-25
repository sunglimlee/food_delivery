import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controller/cart_controller.dart';
import 'package:food_delivery/controller/popular_product_controller.dart';
import 'package:food_delivery/controller/recommended_product_controller.dart';
import 'package:food_delivery/model/products_model.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/utils/readmore_conversion.dart';
import 'package:food_delivery/widget/app_icon.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:get/get.dart';

class RecommendedFoodDetail extends StatelessWidget {
  final int pageId;

  const RecommendedFoodDetail({Key? key, required this.pageId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 선택한 페이지의 프로덕트
    ProductModel product =
        Get.find<RecommendedProductController>().recommendedProductList[pageId];
    // 이줄에서 알아야 할 제일 중요한건 Get 으로 하여금 CartController 를 찾게 해서 항상 하나만 찾게 되도록 한다는 거다. Shopping Cart 이므로 항상 한개의 객체를 가지고 다루어 져야 한다.
    // 이미 Get.layput 이나 get.put 을 통해서 미리 메모리에 만들어져 올라가 있는 걸 사용한다.
    //Get.find<RecommendedProductController>().initProduct(Get.find<CartController>()); // 컨트롤러에서 함수를 찾아서 실행.. initProduct 를 통해서 디테일 페이지를 보여줄 때 quantity 를 초기화를 한다.

    return Scaffold(
      //backgroundColor: Colors.grey,
      // 텍스트의 배경색이 어디서 바뀌는지 봐라. Scaffold 에서 바뀌고 있다.
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            // 자동으로 뒤로가기 버턴 나타나는것 방지해준다.
            toolbarHeight: 70,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.getInitial()); // 홈페이지로 이동
                  },
                  child: const AppIcon(
                    icon: Icons.clear,
                  ),
                ),
                AppIcon(icon: Icons.shopping_cart_outlined)
              ],
            ),
            pinned: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.radius20),
                        topRight: Radius.circular(Dimensions.radius20)),
                    color: Colors.white),
                alignment: Alignment.center,
                width: double.maxFinite,
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                //color: Colors.yellow[400],
                child: BigText(
                  text: product.name!,
                  size: Dimensions.font20,
                ),
              ),
            ),
            expandedHeight: 300,
            backgroundColor: Colors.yellow,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                AppConstants.BASE_URL + AppConstants.UPLOAD_URL + product.img!,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            children: [
              Container(
                //color: Colors.blue,
                margin: EdgeInsets.only(
                    left: Dimensions.edgeInsets20,
                    right: Dimensions.edgeInsets20),
                child: ExpandableText(
                  style: TextStyle(fontSize: Dimensions.font20),
                  product.description!,
                  expandText: ' show more\n',
                  collapseText: ' show less',
                  maxLines: 4,
                  linkColor: Colors.blue,
                ),
              ),
            ],
          )),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        // 이걸 적용함으로써 Column 의 최소한의 높이를 정한다. 만약 없다면 부모가 Scaffold 이므로 전체를 잡아먹도록 된다.
        children: [
          Container(
            margin: EdgeInsets.only(
                left: Dimensions.edgeInsets20 * 2.5,
                right: Dimensions.edgeInsets20 * 2.5,
                top: Dimensions.edgeInsets10,
                bottom: Dimensions.edgeInsets10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppIcon(
                  icon: Icons.remove,
                  backgroundColor: Colors.green[200]!,
                  iconSize: 35,
                ),
                BigText(
                    text: '\$' +
                        Get.find<RecommendedProductController>()
                            .recommendedProductList[pageId]
                            .price
                            .toString() +
                        ' X 0',
                    color: AppColors.mainBlackColor),
                AppIcon(
                  icon: Icons.add,
                  backgroundColor: Colors.green[200]!,
                  iconSize: 25,
                ),
              ],
            ),
          ),
          Container(
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
                        text: '\$0.08',
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
          )
        ],
      ),
    );
  }
}
