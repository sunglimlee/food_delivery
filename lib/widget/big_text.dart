import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overflow;
  // 이제 트랜드는 초기화를 생성자에서 해준다.
  BigText({Key? key, this.color = AppColors.mainBlackColor, required this.text, this.size = 20, this.overflow = TextOverflow.ellipsis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text, overflow: overflow, maxLines: 1,
      style: GoogleFonts.roboto(color: color, fontWeight: FontWeight.w400,fontSize: size),
    );
  }
}
