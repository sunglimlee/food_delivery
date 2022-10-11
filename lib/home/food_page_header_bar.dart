import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:food_delivery/widget/small_text.dart';

class FoodPageHeaderBar extends StatelessWidget {
  const FoodPageHeaderBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: Dimensions.edgeInsets15,
          right: Dimensions.edgeInsets15,
          bottom: Dimensions.edgeInsets15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              BigText(
                text: 'Bangladesh',
                color: AppColors.mainColor,
                size: Dimensions.bigTextSize,
              ),
              Row(
                children: [
                  SmallText(
                    text: 'Narsingdi',
                    color: Colors.black54,
                  ),
                  const Icon(Icons.arrow_drop_down_rounded)
                ],
              ),
            ],
          ),
          Center(
            child: Container(
              width: Dimensions.height45,
              height: Dimensions.height45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  color: AppColors.mainColor),
              child: Icon(size: Dimensions.icon24 ,
                Icons.search,
                color: Colors.yellow[50],
              ),
            ),
          )
        ],
      ),
    );
  }
}
