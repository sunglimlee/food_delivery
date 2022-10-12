import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:food_delivery/widget/icon_and_text.dart';
import 'package:food_delivery/widget/small_text.dart';

class AppColumn extends StatelessWidget {
  final String title;

  const AppColumn({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: Dimensions.edgeInsets20,
          right: Dimensions.edgeInsets20,
          top: Dimensions.edgeInsets20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(Dimensions.radius20),
              topLeft: Radius.circular(Dimensions.radius20)),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigText(
            text: title,
            size: Dimensions.font26,
          ),
          SizedBox(
            height: Dimensions.height10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: List.generate(
                    5,
                    (index) => Icon(
                          Icons.star,
                          color: AppColors.mainColor,
                          size: Dimensions.height15,
                        )),
              ),
              SizedBox(width: Dimensions.height10),
              SmallText(text: '4.5'),
              SizedBox(
                width: Dimensions.height10,
              ),
              SmallText(text: '1287'),
              SizedBox(
                width: Dimensions.height10,
              ),
              SmallText(text: 'comments'),
            ],
          ),
          SizedBox(
            height: Dimensions.height20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              IconAndText(
                  iconData: Icons.circle_sharp,
                  text: 'Normal',
                  iconColor: AppColors.iconColor1),
              IconAndText(
                  iconData: Icons.location_on,
                  text: '1.7km',
                  iconColor: AppColors.mainColor),
              IconAndText(
                  iconData: Icons.circle_sharp,
                  text: '32min',
                  iconColor: AppColors.iconColor2),
            ],
          ),
        ],
      ),
    );
  }
}
