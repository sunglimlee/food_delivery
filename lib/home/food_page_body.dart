import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:food_delivery/widget/icon_and_text.dart';
import 'package:food_delivery/widget/small_text.dart';

/*
/// 페이지뷰를 이렇게 독립적으로 만들어서 나중에 끼워 넣는 방식으로 사용한다.
/// 아주 좋은 방법인것 같다.
 */
class FoodPageBody extends StatefulWidget {
  const FoodPageBody({Key? key}) : super(key: key);

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = 220;

  @override
  void initState() {
    super.initState();
    // 내가 PageController 가 움직일때 값을 받아오기 위해서 Listener 를 연결해주어야 한다.
    pageController.addListener(() {
      setState(() {
        _currPageValue =
            pageController.page!; // 숫자가 0.0 - 1.0 까지 값이 변경되고 있네. page 값으로.. !!!
        print('Current value is ${_currPageValue.toString()}');
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      child: PageView.builder(
          controller: pageController,
          itemCount: 5,
          itemBuilder: (context, position) {
            return _PageViewBuilderItem(position);
          }),
    );
  }

  Widget _PageViewBuilderItem(int position) {
    Matrix4 matrix4 = new Matrix4.identity();
    if (position == _currPageValue.floor()) {
      var currScale = 1 - (_currPageValue - position) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (position == _currPageValue.floor() + 1) {
      var currScale =
          _scaleFactor + (_currPageValue - position + 1) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1);
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (position == _currPageValue.floor() - 1) {
      var currScale = 1 - (_currPageValue - position) * (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      // 3번째 것
      var currScale = 0.8;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }
    return Transform(
      // 이렇게 감싸주면 바뀌는구나.
      transform: matrix4,
      child: Stack(
        children: [
          _mainBody(position),
          _subBody(),
        ],
      ),
    );
  }

  Widget _subBody() {
    // 옆에 패딩을 넣어주기 위해서 Container 를 또 넣어주기로 했지..
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 130,
        margin: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFe8e8e8),
                blurRadius: 5.0,
                offset: Offset(0, 5),
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-5, 0),
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(5, 0),
              ),
            ]),
        child: Container(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BigText(
                text: 'Korean DanJang Soup',
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Wrap(
                    children: List.generate(
                        5,
                        (index) => const Icon(
                              Icons.star,
                              color: AppColors.mainColor,
                              size: 15,
                            )),
                  ),
                  const SizedBox(width: 10),
                  SmallText(text: '4.5'),
                  const SizedBox(
                    width: 10,
                  ),
                  SmallText(text: '1287'),
                  const SizedBox(
                    width: 10,
                  ),
                  SmallText(text: 'comments'),
                ],
              ),
              const SizedBox(
                height: 20,
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
        ),
      ),
    );
  }

  Widget _mainBody(int position) {
    return Container(
        height: _height,
        margin: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: position.isEven ? Colors.green : Colors.pink,
          image: const DecorationImage(
              image: NetworkImage(
                  'https://mblogthumb-phinf.pstatic.net/20160728_110/angtal11_1469678845951ucEXr_JPEG/IMG_7613.JPG?type=w2'),
              fit: BoxFit.cover),
        ));
  }
}
