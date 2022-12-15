
import 'package:flutter/material.dart';
import 'package:food_delivery/utils/dimensions.dart';

// 이건 하나의 TextStyle 객체를 만든건데... 그걸 다른데 넣어주면 되는건가?
final robotoRegular = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w400,
  fontSize: Dimensions.font26,
);

final robotoMedium = robotoRegular.copyWith(fontWeight: FontWeight.w400);

final robotoBold = robotoRegular.copyWith(fontWeight: FontWeight.w700);

final robotoBlack = robotoRegular.copyWith(fontWeight: FontWeight.w900);