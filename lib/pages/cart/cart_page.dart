import 'package:flutter/material.dart';
import 'package:food_delivery/controller/cart_controller.dart';
import 'package:food_delivery/controller/popular_product_controller.dart';
import 'package:food_delivery/controller/recommended_product_controller.dart';
import 'package:food_delivery/model/cart_model.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/app_icon.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:food_delivery/widget/small_text.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CartModel> cartList = Get.find<CartController>().getItems;
    return Scaffold(
      body: Stack(
        children: [
          // 위의 버턴부분들, 재밌는 사실은 이걸 Positioned 로 하지 않고 Container 를 감싸서 margin 으로 조절하고 있다는 점이다. 그래야 나중에  SingleChildScrollView 를 할 수 있다.
          Container(
            margin: EdgeInsets.only(
                left: Dimensions.edgeInsets20,
                right: Dimensions.edgeInsets20,
                top: Dimensions.edgeInsets20 * 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.find<PopularProductController>().update();
                    Get.find<RecommendedProductController>().update();
                    Get.back();
                  },
                  child: AppIcon(
                    icon: Icons.arrow_back,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.mainColor,
                    iconSize: Dimensions.icon24,
                  ),
                ),
                SizedBox(
                  width: Dimensions.edgeInsets20 * 5,
                ),
                // 이렇게 옆으로 더 밀 수도 있구나.
                GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.getInitial());
                  },
                  child: AppIcon(
                    icon: Icons.home_outlined,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.mainColor,
                    iconSize: Dimensions.icon24,
                  ),
                ),
                AppIcon(
                  icon: Icons.shopping_cart_outlined,
                  iconColor: Colors.white,
                  backgroundColor: AppColors.mainColor,
                  iconSize: Dimensions.icon24,
                ),
              ],
            ),
          ),
          Container(
            // 리스트를 감싸고 있는 컨테이너 위치조정 위해 필요 (Positioned 대신 사용하기 위함.)
            // 봐라 모든걸 Dimensions 에 정해놓고 거기에서 곱셈으로 거리를 늘리는 거댜. Positioned 과 사실상 똑같다.
            margin: EdgeInsets.only(
                top: Dimensions.edgeInsets20 * 6,
                left: Dimensions.edgeInsets20,
                right: Dimensions.edgeInsets20),
            //color: Colors.red,
            child: MediaQuery.removePadding(
              // 위의 패딩을 없애기 위해서 사용한다는데 흠.. 새로운거네.. // 못찾겠다. 그러니깐 자동으로 일정 패딩이 적용되는건가?
              context: context,
              removeTop: true,
              child: GetBuilder<CartController>(
                builder: (cartController) {
                  return ListView.builder(
                    //padding: EdgeInsets.all(0), // 리스트뷰에도 자동으로 안쪽으로 패딩이 들어가는 구나.. 그래서 여기서 0을 해주던지 아니면 MediaQuery 를 이용해서 패딩을 강제로 없애든지 해야하는구나.
                    itemCount: cartController.getItems.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        // 리스트 전체를 감싸는 컨테이너
                        width: double.maxFinite, // 전체 페이지의 넓이를 차지하도록 한다.
                        //height: 100,
                        child: Row(
                          // 이미지를 넣어주는 부분
                          children: [
                            GestureDetector(
                              onTap: () {
                                // 리스트에서 Popular food 의 해당 프로덕트에 대한 인덱스를 알아낸다.
                                var popularListIndex =
                                    Get.find<PopularProductController>()
                                        .popularProductList
                                        .indexOf(cartController // ListMap
                                            .getItems[index]
                                            .product!);
                                // 리스트에서 Popular food 의 해당 프로덕트에 대한 인덱스를 알아낸다.
                                var recommendedListIndex =
                                    Get.find<RecommendedProductController>()
                                        .recommendedProductList
                                        .indexOf(cartController
                                            .getItems[index].product!);
                                print(
                                    "in CartPage. itemListIndex =  ${popularListIndex}");
                                if (cartController
                                        .getItems[index].product!.typeId ==
                                    2) {
                                  // popular items
                                  Get.toNamed(RouteHelper.getPopularFood(
                                      popularListIndex, RouteHelper.cartPage));
                                  print(
                                      "in CartPage. cartController.getItems[index].product!.id! ${cartController.getItems[index].product!.id!}");
                                } else {
                                  // recommended Items
                                  print(
                                      "in CartPage. cartController.getItems[index].product!.id! ${cartController.getItems[index].product!.id!}");
                                  Get.toNamed(RouteHelper.getRecommendedFood(
                                      recommendedListIndex,
                                      RouteHelper.cartPage));
                                }
                              },
                              child: Container(
                                width: Dimensions.height20 * 5,
                                height: Dimensions.height20 * 5,
                                margin: EdgeInsets.only(
                                    bottom: Dimensions.height10),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        '${AppConstants.BASE_URL}${AppConstants.UPLOAD_URL}${cartController.getItems[index].img}'), //
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius20),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // 이미지와 텍스트사이 공간을 좀 띄워주고..
                            SizedBox(
                              width: Dimensions.edgeInsets20,
                            ),
                            // 오른쪽에 텍스트와 버턴들을 넣는부분, row, column, flex 에서 남은 부분을 다 채울 때 사용하는 위젯
                            Expanded(
                              child: Container(
                                //color: Colors.red,
                                height: Dimensions.height20 * 5,
                                // 여기서 높이가 정해져 있으니깐 넘어간다고 문제가 나오잖아... 그러니깐 높이를 없애야지.
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // 이름 부붙
                                    BigText(
                                      text:
                                          cartController.getItems[index].name!,
                                      color: Colors.black54,
                                    ),
                                    SmallText(text: "Spice"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //가격부분
                                        BigText(
                                          text:
                                              "\$${cartController.getItems[index].price.toString()}",
                                          color: Colors.redAccent,
                                        ),
                                        Container(
                                          // Shopping Cart 에 수량을 입력하기 위한 버턴부분. 근데 quantity 만 가지고 다루고 있다.
                                          //padding: EdgeInsets.all(Dimensions.edgeInsets20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radius20),
                                              color: Colors.white),
                                          child: Row(
                                            //crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (cartController
                                                          .getItems[index]
                                                          .quantity! >
                                                      1) {
                                                    cartController.addItem(
                                                        cartController
                                                            .getItems[index]
                                                            .product!,
                                                        -1);
                                                  } else {
                                                    cartController.removeItems(
                                                        cartController
                                                            .getItems[index]
                                                            .id!);
                                                  }
                                                },
                                                // 아이콘을 터치하는데 너무 작다.
                                                // https://stackoverflow.com/questions/57114433/increase-tap-detection-area-of-a-widget
                                                child: Container(
                                                  //color: Colors.green,
                                                  padding: EdgeInsets.only(
                                                    right:
                                                        Dimensions.edgeInsets10,
                                                    left:
                                                        Dimensions.edgeInsets10,
                                                    top:
                                                        Dimensions.edgeInsets10,
                                                    bottom:
                                                        Dimensions.edgeInsets10,
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
                                                text: cartController
                                                    .getItems[index].quantity
                                                    .toString(),
                                                //popularProduct.quantity.toString(),
                                                color: Colors.black45,
                                              ),
                                              SizedBox(
                                                width: Dimensions.height10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  cartController.addItem(
                                                      cartController
                                                          .getItems[index]
                                                          .product!,
                                                      1);
                                                  print(
                                                      "in cart_page. being tapped");
                                                },
                                                // 아이콘을 터치하는데 너무 작다.
                                                // https://stackoverflow.com/questions/57114433/increase-tap-detection-area-of-a-widget
                                                child: Container(
                                                  //color: Colors.green,
                                                  padding: EdgeInsets.only(
                                                    left:
                                                        Dimensions.edgeInsets10,
                                                    right:
                                                        Dimensions.edgeInsets10,
                                                    top:
                                                        Dimensions.edgeInsets10,
                                                    bottom:
                                                        Dimensions.edgeInsets10,
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
                                      ],
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
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          GetBuilder<CartController>(builder: (cartController) {
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
                    SizedBox(
                      width: Dimensions.height10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: Dimensions.edgeInsets20,
                          bottom: Dimensions.edgeInsets20,
                          left: Dimensions.edgeInsets5,
                          right: Dimensions.edgeInsets5),
                      child: BigText(
                        text:
                            "Total Items : ${cartController.totalItems.toString()}",
                        //popularProduct.quantity.toString(), TODO
                        color: Colors.black45,
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.height10,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.only(
                      top: Dimensions.edgeInsets20,
                      bottom: Dimensions.edgeInsets20,
                      left: Dimensions.edgeInsets15,
                      right: Dimensions.edgeInsets15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: Colors.green[200]),
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BigText(
                        size: Dimensions.font16,
                        text:
                            '\$${double.parse(cartController.totalAmount.toString())}',
                        color: Colors.black45,
                      ),
                      SizedBox(
                        width: Dimensions.height20,
                      ),
                      BigText(
                        text: 'Checkout',
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
