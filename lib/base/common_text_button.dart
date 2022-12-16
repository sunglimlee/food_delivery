import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/big_text.dart';

class CommonTextButton extends StatelessWidget {
  String buttonTitle;

  CommonTextButton({Key? key, required this.buttonTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: Dimensions.edgeInsets20,
          bottom: Dimensions.edgeInsets20,
          left: Dimensions.edgeInsets10,
          right: Dimensions.edgeInsets10),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                blurRadius: 10,
                color: AppColors.mainColor.withOpacity(0.3)),
          ],
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          color: Colors.white),
      child: Center(
        child: BigText(
          text: buttonTitle,
          color: Colors.white,
        ),
      ),
    );
  }
}
