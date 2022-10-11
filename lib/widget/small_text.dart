import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:google_fonts/google_fonts.dart';

class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  double height;

  // 이제 트랜드는 초기화를 생성자에서 해준다.
  SmallText(
      {Key? key,
      this.color = AppColors.textColor,
      required this.text,
      this.size = 0,
      this.height = 1.2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.roboto(
          color: color,
          fontSize: (size == 0) ? Dimensions.smallTextSize : size,
          height: height),
    );
  }
}
