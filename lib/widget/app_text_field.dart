import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController _textEditingController;
  final String _hintText;
  final IconData _iconData;
  int maxLines;

  AppTextField(
      {required String hintText, // 이건 required 를 했고
      IconData iconData =
          Icons.tag_faces_rounded, // 이건 기본값을 넣어주었고, 그래서 파라미터를 넘기지 않아도 된다.
      this.maxLines = 1,
      required TextEditingController textEditingController,
      Key? key})
      : _hintText = hintText,
        _iconData = iconData,
        _textEditingController = textEditingController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: Dimensions.height20, right: Dimensions.height20),
      decoration: BoxDecoration(
        // 그러니깐 전체적으로 borderRadius 를 밑에꺼와 같이  3개를 맞추어 주어야 제대로 예쁘게 된다. 안맞추주니깐 이거 하기전에는 그냥 박스로 나타나잖아...
        borderRadius: BorderRadius.circular(Dimensions.radius15),
        color: Colors.white, // 이걸 안넣으니 전체적으로 흐리멍텅하게 채워진다.
        boxShadow: [
          BoxShadow(
              // 밑에 3개의 값들을 줄여주니깐 글래스 효과가 나오는구나..
              blurRadius: 3,
              spreadRadius: 1,
              offset: const Offset(1, 1), //
              color: Colors.grey.withOpacity(0.2)),
        ],
      ),
      child: TextField(
        maxLines: maxLines,
        obscureText: (_hintText == "Password") ? true : false,
        controller: _textEditingController,
        //hintText, //prefixIcon, //focusedBorder, //enabledBorder, //border
        decoration: InputDecoration(
          hintText: _hintText,
          prefixIcon: Icon(
            _iconData,
            color: AppColors.yellowColor,
          ),
          // focused Border, 포커스를 받았을 때 나타나는 테두리
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide:
                  const BorderSide(width: 1.0, color: Colors.cyanAccent)),
          // enabled Border, 포커스와 똑같이 맞추려고 한것임.
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              borderSide:
                  const BorderSide(width: 1.0, color: Colors.cyanAccent)),
        ),
      ),
    );
  }
}
