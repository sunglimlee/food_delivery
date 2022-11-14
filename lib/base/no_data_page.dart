import 'package:flutter/material.dart';

// 여러군데서 사용하는데 왜 Widget 안에 안넣고 base 에 넣는지는 모르겠지만 뭐.. 따라가보지..
class NoDataPage extends StatelessWidget {
  final String text;
  final String imgPath;

  const NoDataPage(
      {Key? key,
      required this.text,
      this.imgPath = "assets/images/undraw_empty_cart_co35.png"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          imgPath,
          height: MediaQuery.of(context).size.height * 0.22,
          width: MediaQuery.of(context).size.height * 0.22,
        ),
        //SizedBox(height: MediaQuery.of(context).size.height*0.33,),
        Text(
          text,
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.0175,
              color: Theme.of(context).disabledColor),
        )
      ],
    );
  }
}
