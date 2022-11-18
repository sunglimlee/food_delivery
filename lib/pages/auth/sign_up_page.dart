import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_loader.dart';
import 'package:food_delivery/base/show_custom_snackbar.dart';
import 'package:food_delivery/controller/auth_controller.dart';
import 'package:food_delivery/model/signup_body_model.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/app_text_field.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  // 잘 기억하자. 여기 build 함수안에다가 TextEditingController 를 만들어도 된다.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  // 다른 곳의 signup 아이콘을 위한 이미지 리스트
  final signUpImages = ["f.png", "i.png", "t.png"];

  SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // CircleAvatar 에 사용할 이미지를 List 로 저장하고 사용하는 걸 보여준다.
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (authController) {
        // 홈화면으로 보낼지 결정
        return !authController.isLoading ? SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          // 유저가 스크롤 할 때 어떻게 반응하게 할건지 정하는 부분,
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
              // email
              AppTextField(
                  hintText: "Email",
                  iconData: Icons.email,
                  textEditingController: emailController),
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
              // name
              AppTextField(
                  hintText: "Name",
                  iconData: Icons.person,
                  textEditingController: nameController),
              SizedBox(
                height: Dimensions.height20,
              ),
              // phone
              AppTextField(
                  hintText: "Phone",
                  iconData: Icons.phone,
                  textEditingController: phoneController),
              SizedBox(
                height: Dimensions.height20,
              ),
              // Signup Button, message, other method's message & buttons
              GestureDetector(
                onTap: () {
                  // 항상 Validation 위해 함수를 이용하도록 한다.
                  _registration(authController);
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
                    text: "Sign Up",
                    size: Dimensions.font20 + Dimensions.font20 / 2,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: Dimensions.height10,
              ),
              // 전체적인 구문을 넣기에 좋은 위젯이고, 이미 알고 있고 몇가지 제약에 해당하는 걸 꼭 넣어주어야 한다.
              // <a href=""></a> 이것과 비슷한것이다.
              // TapGestureRecognizer()..onTap = ()=> // 이구문을 잘봐라.. 함수에 Anonymous 함수를 대입시켜 주었다. 그래서 함수의 이름으로만 했기때문에 () 괄호가 안들어간 것이다.
              // Tag Line
              RichText(
                text: TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () => Get.back()
                    // GestureDetector 와 비슷한 건데 TextSpan 에서 사용하는 것
                    ,
                    text: "Have an account already?",
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: Dimensions.font20)),
              ),
              SizedBox(
                height: Dimensions.screenHeight * 0.05,
              ),
              // Signup options
              RichText(
                text: TextSpan(
                    text: "sign Up using one of the following methods",
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: Dimensions.font16)),
              ),
              Wrap(
                // 여기 보이지? 다음줄로 넘겨주는 위젯 Wrap 을 사용하고 있다는 것
                children: List.generate(
                    3,
                        (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: Dimensions.radius30,
                        backgroundImage: AssetImage(
                          "assets/images/${signUpImages[index]}",
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ) : const CustomLoader();
      },),
    );
  }

  // 들어온 값들이 문제가 없는지 Validation 하는 함수로 만약 이함수를 Build 함수 안에다가 위의 컨트롤러 변수안에 같이 넣으려면 반드시 Build 함수 상단에 넣어야 한다.
  Future<void> _registration(AuthController authController) async {
    //var authController = Get.find<AuthController>(); // UI 에서 컨트롤러를 사용하기 위히서 필요하다.
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String email = emailController.text.trim();
    // 전부 문제가 있는걸 걸러준다.
    if (email.isEmpty) {
      showCustomSnackBar("Type in your email", title: "Email");
      return;
    }
    if (!GetUtils.isEmail(email)) {
      showCustomSnackBar("Type in correct email", title: "Email Format");
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
    if (name.isEmpty) {
      showCustomSnackBar("Type in your name", title: "Name");
      return;
    }
    if (phone.isEmpty) { // 나중에 전화번호 길이도 체크해주자.
      showCustomSnackBar("Type in your Phone Number", title: "Phone Number");
      return;
    }
    // 위의걸 모두 통과하면
    {
      showCustomSnackBar("All looks good", title: "Perfect");
      SignUpBody signUpBody = SignUpBody(name: name, phone: phone, email: email, password: password);
      //print(signUpBody.toString());
      // 여기에서는 then 을 사용하였네..
      authController.registration(signUpBody).then((responseModel) {
        print("LSL:in sign_up_page.dart");
        if (responseModel.isSuccess) {
          print("Success registration");
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
