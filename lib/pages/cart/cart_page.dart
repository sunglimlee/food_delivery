import 'package:flutter/material.dart';
import 'package:food_delivery/base/no_data_page.dart';
import 'package:food_delivery/base/show_custom_snackbar.dart';
import 'package:food_delivery/controller/auth_controller.dart';
import 'package:food_delivery/controller/cart_controller.dart';
import 'package:food_delivery/controller/location_controller.dart';
import 'package:food_delivery/controller/order_controller.dart';
import 'package:food_delivery/controller/popular_product_controller.dart';
import 'package:food_delivery/controller/recommended_product_controller.dart';
import 'package:food_delivery/controller/user_controller.dart';
import 'package:food_delivery/model/cart_model.dart';
import 'package:food_delivery/model/place_order_model.dart';
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
          _buttonsOnTop(),
          // ListView 부분
          _listViewPart(),
        ],
      ),
      // BottomNavigation 부분
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Widget _buttonsOnTop() {
    return Container(
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
    );
  }

  Widget _bottomNavBar() {
    return GetBuilder<CartController>(builder: (cartController) {
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
        child: (cartController.getItems.length > 0)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // Shopping Cart 에 수량을 입력하기 위한 작업. 근데 quantity 만 가지고 다루고 있다.
                    //padding: EdgeInsets.all(Dimensions.edgeInsets20),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
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
                    // 체크아웃 버턴 부분
                    onTap: () {
                      // Login 이 되어 있는지 확인하는 부분
                      if (Get.find<AuthController>().userLoggedIn()) {
                        print("LSL : in cart_page.dart >>> logged in? <<<");

                        // 주소가 비어있다면
                        if (Get.find<LocationController>()
                            .addressList
                            .isEmpty) {
                          print(
                              "LSL : in cart_page.dart >>> yes. logged in. <<<");
                          Get.toNamed(RouteHelper.getAddAddressPage());
                        } else {
                          //Get.offNamed(RouteHelper.getInitial()); // 주소가 리스트에 존재한다면  초기화면으로 가게 하면 된다. 그렇지만 뒤에거가 계속 실행되는거지.
                          // 여기에서 payment 페이지로 가도록 한다. 왜냐하면 오더했고 유저도 로그인상태이므로 카트버턴을 눌렀으니 payment 로 가야지..
                          //Get.offNamed(RouteHelper.getPaymentPage("27", Get.find<UserController>().userModel!.id!));
                          // 여기서 잘봐라. 함수의 결과값을 넘기려면 _callback(xxx) 라고 넘겼겠지만 잘보면 그냥 함수의 이름만 넘기고 있다. 그말은 콜백함수로 넘기겠다는 뜻이다.
                          // 여기서 이제까지 만든 PlaceOrderModel 을 넘겨주도록 하자.. 그러니깐 여기서 모델의 객체를 한꺼번에 다 만들어서 넘겨준다는 거지.
                          // 모델을 만들어서 그 내용을 넘겨주려면 추가로 다른부분에서 데이터를 접근해서 가지고 와야하는구나..
                          var location =
                              Get.find<LocationController>().getUserAddress();
                          var cart = Get.find<CartController>().getItems;
                          var user = Get.find<UserController>().userModel;
                          PlaceOrderModel placeOrderModel = PlaceOrderModel(
                              cart: cart,
                              orderAmount: 100.00,
                              orderNote: 'Not note Yet',
                              distance: 10,
                              address: location.address,
                              latitude: location.latitude,
                              longitude: location.longitude,
                              contactPersonName: user.fName,
                              contactPersonNumber: user.phone);
                          // 이렇게 수집해서 만든 객체를 이제 간편하게 통째로 함수로 넘겨준다.
                          Get.find<OrderController>()
                              .placeOrder(placeOrderModel, _callback);
                        }
                        // address 도 있으면 이제 쇼핑카트로 간다.
                        // 현재 쇼핑카트에 있는 CartModel 의 String 버전인 리스트를 히스토리를 위한 리스트에 복사를 한다. 이거 한다고 cartController 부르고 그게 다시 CarRepo 를 부르네..
                        print("in car_page. Tapped????");
                        cartController.addToHistory();
                      } else {
                        // 이 부분을 내가 일부러 getter 를 사용했다. getter 사용하니깐 괄호를 넣을 필요가 없네..
                        Get.toNamed(RouteHelper.getSignInPage);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: Dimensions.edgeInsets20,
                          bottom: Dimensions.edgeInsets20,
                          left: Dimensions.edgeInsets15,
                          right: Dimensions.edgeInsets15),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
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
              )
            : Container(),
      );
    });
  }

  Widget _listViewPart() {
    return Container(
      // 리스트를 감싸고 있는 컨테이너 위치조정 위해 필요 (Positioned 대신 사용하기 위함.)
      // 봐라 모든걸 Dimensions 에 정해놓고 거기에서 곱셈으로 거리를 늘리는 거댜. Positioned 과 사실상 똑같다.
      margin: EdgeInsets.only(
          top: Dimensions.edgeInsets20 * 6,
          left: Dimensions.edgeInsets20,
          right: Dimensions.edgeInsets20),
      //color: Colors.red,
      child: MediaQuery.removePadding(
        // 리스트뷰에 기본적으로 적용되는 padding 을 지워준다.
        context: Get.context!,
        removeTop: true,
        child: GetBuilder<CartController>(
          builder: (cartController) {
            return (cartController.getItems.length < 1)
                ? _noProduct_inListViewPart()
                : ListView.builder(
                    // 되도록이면 ListView.builder 를 사용하자. 대용량의 자료처리에 적합하다.
                    //padding: EdgeInsets.all(0), // 리스트뷰에도 자동으로 안쪽으로 패딩이 들어가는 구나.. 그래서 여기서 0을 해주던지 아니면 MediaQuery 를 이용해서 패딩을 강제로 없애든지 해야하는구나.
                    itemCount: cartController.getItems.length,
                    itemBuilder: ((context, index) {
                      // 리스트 전체를 감싸는 컨테이너
                      return Container(
                        width: double.maxFinite, // 전체 페이지의 넓이를 차지하도록 한다.
                        //height: 100,
                        child: Row(
                          // 이미지를 부분
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
                                // 리스트에서 Recommended food 의 해당 프로덕트에 대한 인덱스를 알아낸다.
                                var recommendedListIndex =
                                    Get.find<RecommendedProductController>()
                                        .recommendedProductList
                                        .indexOf(cartController
                                            .getItems[index].product!);
                                print(
                                    "in CartPage. itemListIndex =  ${popularListIndex}");
                                if (popularListIndex >= 0) {
                                  // popular items
                                  Get.toNamed(RouteHelper.getPopularFood(
                                      popularListIndex, RouteHelper.cartPage));
                                  print(
                                      "in CartPage. cartController.getItems[index].product!.id! ${cartController.getItems[index].product!.id!}");
                                } else {
                                  if (recommendedListIndex < 0) {
                                    // 히스토리 페이지에서 가지고 프로덕트가 더이상 사용할 수 없을 수도 있기 때문에 그냥 라우팅 못한다고 메세지를 띄워준다.
                                    Get.snackbar("History Product.",
                                        "Product review is not available for the history product.",
                                        backgroundColor: AppColors.mainColor,
                                        colorText: Colors.black);
                                  } else {
                                    // recommended Items
                                    print(
                                        "in CartPage. cartController.getItems[index].product!.id! ${cartController.getItems[index].product!.id!}");
                                    Get.toNamed(RouteHelper.getRecommendedFood(
                                        recommendedListIndex,
                                        RouteHelper.cartPage));
                                  }
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
                                    // 제목 부분
                                    BigText(
                                      text:
                                          cartController.getItems[index].name!,
                                      color: Colors.black54,
                                    ),
                                    SmallText(text: "Spice"),
                                    // 가격과 수량 조정 부분
                                    _priceAndQtyPart_inListViewPart(
                                        cartController, index),
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
    );
  }

  _priceAndQtyPart_inListViewPart(CartController cartController, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //가격부분
        BigText(
          text: "\$${cartController.getItems[index].price.toString()}",
          color: Colors.redAccent,
        ),
        // Shopping Cart 에 수량을 입력하기 위한 버턴부분. 근데 quantity 만 가지고 다루고 있다.
        Container(
          //padding: EdgeInsets.all(Dimensions.edgeInsets20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius20),
              color: Colors.white),
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (cartController.getItems[index].quantity! > 1) {
                    cartController.addItem(
                        cartController.getItems[index].product!, -1);
                  } else {
                    cartController
                        .removeItems(cartController.getItems[index].id!);
                  }
                },
                // 아이콘을 터치하는데 너무 작다.
                // https://stackoverflow.com/questions/57114433/increase-tap-detection-area-of-a-widget
                child: Container(
                  //color: Colors.green,
                  padding: EdgeInsets.only(
                    right: Dimensions.edgeInsets10,
                    left: Dimensions.edgeInsets10,
                    top: Dimensions.edgeInsets10,
                    bottom: Dimensions.edgeInsets10,
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
                text: cartController.getItems[index].quantity.toString(),
                //popularProduct.quantity.toString(),
                color: Colors.black45,
              ),
              SizedBox(
                width: Dimensions.height10,
              ),
              GestureDetector(
                onTap: () {
                  cartController.addItem(
                      cartController.getItems[index].product!, 1);
                  print("in cart_page. being tapped");
                },
                // 아이콘을 터치하는데 너무 작다.
                // https://stackoverflow.com/questions/57114433/increase-tap-detection-area-of-a-widget
                child: Container(
                  //color: Colors.green,
                  padding: EdgeInsets.only(
                    left: Dimensions.edgeInsets10,
                    right: Dimensions.edgeInsets10,
                    top: Dimensions.edgeInsets10,
                    bottom: Dimensions.edgeInsets10,
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
    );
  }

  /// 카트에 아무것도 없다면 전체화면으로 보여주는 위젯
  Widget _noProduct_inListViewPart() =>
      Center(child: const NoDataPage(text: "Shopping cart is empty."));

  /// 주문한후 Payment 결과의 성공여부에 따라 화면전환하는 콜백함수
  _callback(
    bool isSuccess,
    String message,
    String orderId,
  ) {
    if (isSuccess) {
      Get.find<CartController>().clear();
      Get.find<CartController>().removeCartSharedPreference();
      Get.find<CartController>().addToHistory();
      Get.offNamed(RouteHelper.getPaymentPage(
          orderId, Get.find<UserController>().userModel!.id!));
    } else {
      showCustomSnackBar(message);
    }
  }
}
