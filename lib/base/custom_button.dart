// 큰 지도 화면의 아랫부분에 버턴으로 사용하기 위한 Custom Button
import 'package:flutter/material.dart';
import 'package:food_delivery/utils/dimensions.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed; // 이것도 이제 편하네..
  final String buttonText;
  final bool transparant;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double radius;
  final IconData? iconData;

  CustomButton(
      {Key? key,
      required this.onPressed,
      required this.buttonText,
      this.transparant = false,
      this.margin,
      this.height,
      this.width,
      this.fontSize,
      this.radius = 5,
      this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 이말은 결국 TextButton 을 사용할 건데... 좀더 거기서 사용되는 스타일을 좀더 꾸며서 ButtonStyle 객체로 만든다음
    final ButtonStyle _buttonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null
          ? Theme.of(context).disabledColor
          : transparant
              ? Colors.transparent
              : Theme.of(context).primaryColor,
      minimumSize: Size(width != null ? width! : Dimensions.screenWidth,
          height != null ? height! : 50),
      padding: EdgeInsets.zero, // 기본 패딩을 없애기 위해서 사용하는거 아닐까?
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    return Center(
      child: SizedBox(
        width: width ?? Dimensions.screenWidth,
        height: height ?? 50,
        child: TextButton(
          onPressed: () { onPressed;},
          style: _buttonStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconData != null
                  ? Padding(
                      padding:
                          EdgeInsets.only(right: Dimensions.edgeInsets10 / 2),
                      child: Icon(
                        iconData,
                        color: transparant
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor,
                      ),
                    )
                  : SizedBox(),
              Text(
                buttonText,
                style: TextStyle(
                  fontSize: fontSize ?? Dimensions.font16,
                  color: transparant
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).cardColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
