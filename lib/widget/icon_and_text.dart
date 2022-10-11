import 'package:flutter/material.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/small_text.dart';

class IconAndText extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color iconColor;

  const IconAndText(
      {Key? key,
      required this.iconData,
      required this.text,
      required this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         Icon(
          iconData,
          color: iconColor,
           size: Dimensions.icon24,
        ),
        SizedBox(
          width: Dimensions.height5,
        ),
        SmallText(
          text: text,
        ),
      ],
    );
  }
}
