import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:food_delivery/widget/small_text.dart';

class FoodPageHeaderBar extends StatelessWidget {
  const FoodPageHeaderBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15,bottom: 15),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              BigText(
                text: 'Bangladesh',
                color: AppColors.mainColor,
                size: 28,
              ),
              Row(
                children: [
                  SmallText(text: 'Narsingdi', color: Colors.black54,),
                  Icon(Icons.arrow_drop_down_rounded)
                ],
              ),
            ],
          ),
          Center(
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.mainColor),
              child: Icon(
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
