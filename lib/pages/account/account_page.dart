import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_loader.dart';
import 'package:food_delivery/controller/auth_controller.dart';
import 'package:food_delivery/controller/cart_controller.dart';
import 'package:food_delivery/controller/location_controller.dart';
import 'package:food_delivery/controller/user_controller.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/account_widget.dart';
import 'package:food_delivery/widget/app_icon.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 로그인 되었는지 확인하는 함수
    bool userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (userLoggedIn) {
      Get.find<UserController>().getUserInfo();
      print("LSL : in account_page.dart. >>> User has logged in.");
    }
    return Scaffold(
      // 앱바 영역
      appBar: AppBar(
        title: BigText(text: "Profile", size: 24, color: Colors.white),
        backgroundColor: AppColors.mainColor,
      ),
      // controller 의 값이 바뀌었고 update() 가 일어나면 여기서 데이터르 바구어 주어야 하기 때문에 GetBuilder 로 감싸주어야 한다.
      body: GetBuilder<UserController>(builder: (userController) {
        // 아! 헷갈리게 두개나 걸어놨네....
        return userLoggedIn
            ? (userController.isLoading
                ? Container(
                    width: double.maxFinite, // 최대한 사이즈를 확보해 주는 것.
                    margin: EdgeInsets.only(
                      top: Dimensions.height20,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // 큰 아이콘 부분
                          AppIcon(
                            icon: Icons.person,
                            backgroundColor: AppColors.mainColor,
                            iconColor: Colors.white,
                            iconSize: Dimensions.height45 + Dimensions.height30,
                            size: Dimensions.height15 * 10,
                          ),
                          // 각 내용
                          SizedBox(
                            height: Dimensions.height30,
                          ),
                          // Profile Icon
                          // name
                          AccountWidget(
                              appIcon: AppIcon(
                                icon: Icons.person,
                                backgroundColor: AppColors.mainColor,
                                iconColor: Colors.white,
                                iconSize: Dimensions.height10 * 5 / 2,
                                size: Dimensions.height10 * 5,
                              ),
                              bigText: BigText(
                                text: userController.userModel.fName.toString(),
                              )),
                          SizedBox(
                            height: Dimensions.height30,
                          ),
                          // phone
                          AccountWidget(
                              appIcon: AppIcon(
                                icon: Icons.phone,
                                backgroundColor: AppColors.yellowColor,
                                iconColor: Colors.white,
                                iconSize: Dimensions.height10 * 5 / 2,
                                size: Dimensions.height10 * 5,
                              ),
                              bigText: BigText(
                                text: userController.userModel.phone.toString(),
                              )),
                          SizedBox(
                            height: Dimensions.height30,
                          ),
                          // email
                          AccountWidget(
                              appIcon: AppIcon(
                                icon: Icons.email,
                                backgroundColor: AppColors.yellowColor,
                                iconColor: Colors.white,
                                iconSize: Dimensions.height10 * 5 / 2,
                                size: Dimensions.height10 * 5,
                              ),
                              bigText: BigText(
                                text: userController.userModel.email.toString(),
                              )),
                          SizedBox(
                            height: Dimensions.height30,
                          ),
                          // address
                          GetBuilder<LocationController>(builder: (locationController) {
                            if (userLoggedIn && locationController.addressList.isEmpty) {
                              return GestureDetector(
                                onTap: (){
                                  Get.offNamed(RouteHelper.getAddAddressPage());
                                },
                                child: AccountWidget(
                                    appIcon: AppIcon(
                                      icon: Icons.location_on,
                                      backgroundColor: AppColors.mainColor,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.height10 * 5 / 2,
                                      size: Dimensions.height10 * 5,
                                    ),
                                    bigText: BigText(
                                      text: "36 Mayland Trail, Stoney Creek, L8J0G4",
                                    )),
                              );
                            } else {
                              return GestureDetector(
                                onTap: (){
                                  Get.offNamed(RouteHelper.getAddAddressPage());
                                },
                                child: AccountWidget(
                                    appIcon: AppIcon(
                                      icon: Icons.location_on,
                                      backgroundColor: AppColors.mainColor,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.height10 * 5 / 2,
                                      size: Dimensions.height10 * 5,
                                    ),
                                    bigText: BigText(
                                      text: "Your Address",
                                    )),
                              );
                            }
                          }),
                          SizedBox(
                            height: Dimensions.height30,
                          ),
                          // message
                          AccountWidget(
                              appIcon: AppIcon(
                                icon: Icons.message_outlined,
                                backgroundColor: Colors.redAccent,
                                iconColor: Colors.white,
                                iconSize: Dimensions.height10 * 5 / 2,
                                size: Dimensions.height10 * 5,
                              ),
                              bigText: BigText(
                                text: "Message",
                              )),
                          SizedBox(
                            height: Dimensions.height30,
                          ),
                          // Logout
                          GestureDetector(
                            // 내생각에는 여기만 바뀌면 되는게 아니라 전부 다바뀌어야 할 것 같은데.. 그래서
                            onTap: () {
                              if (Get.find<AuthController>().userLoggedIn()) {
                                Get.find<AuthController>().clearSharedData();
                                Get.find<CartController>().removeCart();
                                Get.find<CartController>().removeCartHistory();
                                Get.find<LocationController>().clearAddressList(); // 주소리스트를 전부 지워준다.
                                Get.find<CartController>().updateCart();
                                Get.toNamed(RouteHelper.getSignInPage);
                              } else {
                                print(
                                    "LSL : in account_page.dart >>> You logged out <<<");
                              }
                            },
                            child: AccountWidget(
                                appIcon: AppIcon(
                                  icon: Icons.logout,
                                  backgroundColor: Colors.redAccent,
                                  iconColor: Colors.white,
                                  iconSize: Dimensions.height10 * 5 / 2,
                                  size: Dimensions.height10 * 5,
                                ),
                                bigText: BigText(
                                  text: "Logout",
                                )),
                          ),
                          SizedBox(
                            height: Dimensions.height30,
                          ),
                        ],
                      ),
                    ),
                  )
                : const CustomLoader())
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: Dimensions.height20 * 10,
                      margin: EdgeInsets.only(left: Dimensions.height20),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                "assets/images/Food_Delivery_Splash_Logo-1.png")),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getSignInPage);
                      },
                      child: Container(
                        width: double.maxFinite,
                        height: Dimensions.height20 * 5,
                        margin: EdgeInsets.only(left: Dimensions.height20),
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                        ),
                        child: Center(
                            child: BigText(
                          text: "Sign in ",
                          color: Colors.white,
                          size: Dimensions.font20,
                        )),
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
