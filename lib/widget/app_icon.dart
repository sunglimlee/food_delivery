import 'package:flutter/material.dart';
import 'package:food_delivery/utils/dimensions.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double iconSize;
  final double size;

  // [error] The default value of an optional parameter must be constant.
  // [answer] put const Color(0xFFfcf4e4)
  const AppIcon(
      {Key? key,
      required this.icon,
      this.backgroundColor = const Color(0xFFfcf4e4),
      this.iconColor = const Color(0xFF756d54),
      this.iconSize = 0,
      this.size = 40})
      : super(key: key);

  // TODO 여기 바꿔야 된다. Dimensions
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            BorderRadius.circular(size / 2), // 잘봐라.. 동그라미 그리는것 size /2
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: (iconSize == 0) ? Dimensions.icon16 : iconSize,
      ),
    );
  }
}
