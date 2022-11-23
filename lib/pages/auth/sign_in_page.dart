import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_loader.dart';
import 'package:food_delivery/base/show_custom_snackbar.dart';
import 'package:food_delivery/controller/auth_controller.dart';
import 'package:food_delivery/model/signup_body_model.dart';
import 'package:food_delivery/pages/auth/sign_up_page.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/app_text_field.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:get/get.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // CircleAvatar 에 사용할 이미지를 List 로 저장하고 사용하는 걸 보여준다.
    return Scaffold(
      backgroundColor: Colors.white,
      // 이제는 알지? GetBuilder 하는 이유.. stateManagement 의 내용이 바뀔때 갱신하도록 하기 위해서 감싸준다는 거지..
      body: GetBuilder<AuthController>(builder: (authController) {
        return !authController.isLoading ? SingleChildScrollView(
          physics: const BouncingScrollPhysics(),// 유저가 스크롤 할 때 어떻게 반응하게 할건지 정하는 부분,
          child: Column(
            children: [
              // App Logo
              Container(
                margin: EdgeInsets.only(
                    top: Dimensions.screenHeight * 0.05,
                    bottom: Dimensions.screenHeight * 0.05),
                height: Dimensions.screenHeight * 0.25,
                //width: double.infinity,
                alignment: Alignment.center,
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  // 여기에 배경을 넣어주니 이미지 배경이 지워지네!!!, png 파일이니깐..
                  radius: 80,
                  // 추후에 이미지 배경을 투명하게 만들고 싶은데..
                  backgroundImage: AssetImage(
                    "assets/images/Food_Delivery_Splash_Logo-1.png",
                  ),
                ),
              ),
              // SignIn 문구 Hello Sign into your account
              Container(
                width: double.infinity, // 역시 Container 는 자식을 감싸고 돌기때문에 width 를 주어야한다. 거의 대부분 double.infinity 로 설정
                margin: EdgeInsets.only(left: Dimensions.edgeInsets20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello", style: TextStyle(fontSize: Dimensions.font20*3+Dimensions.font20/2, fontWeight: FontWeight.bold),),
                    Text("Sign into your account", style: TextStyle(fontSize: Dimensions.font20, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              SizedBox(
                height: Dimensions.height20,
              ),
              // phone
              AppTextField(
                  hintText: "email",
                  iconData: Icons.phone,
                  textEditingController: phoneController),
              SizedBox(
                height: Dimensions.height20,
              ),
              // password
              AppTextField(
                  hintText: "Password",
                  iconData: Icons.password_sharp,
                  textEditingController: passwordController),
              SizedBox(
                height: Dimensions.height20,
              ),
              // Sign into your account Text 부분
              Padding(
                padding: EdgeInsets.only(right: Dimensions.edgeInsets20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Expanded(child: Container()), DBESTech 는 이렇게 작업했는데 나는 Expanded 안쓰고 그냥 MainAxisAlignment.end 를 이용했다.
                    RichText(
                      text: TextSpan(
                          text: "Sign into your account",
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: Dimensions.font20)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Dimensions.height20,
              ),

              // SignIn Button, message, other method's message & buttons
              GestureDetector(
                onTap: () {
                  _login(authController);
                },
                child: Container(
                  alignment: Alignment.center,
                  // 그래서 Container 안에 Alignment 가 있는 거구나. 그리고 자동으로 완전 중앙으로 가게 해주고
                  width: Dimensions.screenWidth / 2,
                  height: Dimensions.screenHeight / 13,
                  // 왜 13일까? 어떤 계산식이 존재하는 걸까??
                  // 여기서 보듯이 decoration 은 컨테이너의 전체적인 모양을 구성하게 해준다. 이제는 알겠지?
                  // 그리고 컨테이는 내용물을 기준으로 모양이 정해지기 때문에 이게 가능하다는 거지..
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                    color: AppColors.mainColor,
                  ),
                  child: BigText(
                    text: "Sign In",
                    size: Dimensions.font20 + Dimensions.font20 / 2,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.height20*2,
              ),
              // 전체적인 구문을 넣기에 좋은 위젯이고, 이미 알고 있고 몇가지 제약에 해당하는 걸 꼭 넣어주어야 한다.
              // <a href=""></a> 이것과 비슷한것이다.
              // TapGestureRecognizer()..onTap = ()=> // 이구문을 잘봐라.. 함수에 Anonymous 함수를 대입시켜 주었다. 그래서 함수의 이름으로만 했기때문에 () 괄호가 안들어간 것이다.
              // Tag Line
              RichText(
                text: TextSpan(
                    text: "Don\'t have an account? ",
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: Dimensions.font20),
                    // 잘봐라.. 여기 TextSpan 에는 children 이 들어가서 추가로 단어들이나 문장을 따로 관리 할 수 있다.
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()..onTap = ()=> Get.to(()=> SignUpPage(), transition: Transition.fade),
                        text: "Create ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500], fontSize: Dimensions.font20),)
                    ]),
              ),
              SizedBox(height: Dimensions.screenHeight*0.05,),
            ],
          ),
        ) : const CustomLoader();
      },)
    );
  }
  Future<void> _login(AuthController authController) async {
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    // 전부 문제가 있는걸 걸러준다.
    if (phone.isEmpty) { // 나중에 전화번호 길이도 체크해주자.
      showCustomSnackBar("Type in your email", title: "email");
      return;
    }
    if (password.isEmpty) {
      showCustomSnackBar("Type in your password", title: "Password");
      return;
    }
    if (password.length < 6) {
      showCustomSnackBar("Password must be more than 6 characters", title: "Password length");
      return;
    }
    // 위의걸 모두 통과하면
        {
      showCustomSnackBar("All looks good", title: "Perfect");
      //print(signUpBody.toString());
      // 여기에서는 then 을 사용하였네..
      authController.login(phone, password).then((responseModel) {
        print("LSL:in sign_up_page.dart");
        if (responseModel.isSuccess) {
          // 이제 홈 화면으로 넘겨줘야지..
          Get.toNamed(RouteHelper.getInitial());
          // Cart 페이지로 테스트차원에서 넘겨주네..
          //Get.toNamed(RouteHelper.getCartPage());
        } else { // 실패했으면
          showCustomSnackBar(responseModel.message.toString());
        }
      });

/*
      var ttt = await authController.registration(signUpBody);
      if (ttt.isSuccess) {}
      // 이렇게 해도 위에꺼와 동일한 기능을 수향할 수 있다. 한가지 차이점은
      // await 는 이줄에서 기다리고 있는거고..
      // then 은 이후의 줄을 계속 실행시키고 있다는 거고..
*/

    }
  }
}
