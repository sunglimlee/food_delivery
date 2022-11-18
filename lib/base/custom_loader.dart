import 'package:flutter/material.dart';
import 'package:food_delivery/controller/auth_controller.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("LSL: I am printing loading state ${Get.find<AuthController>().isLoading.toString()}");
    return Container(
      height: Dimensions.height20*5,
      width: Dimensions.height20*5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.height20*5/2),
        color: AppColors.mainColor,
      ),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(color: Colors.white,),


    );
  }
}
