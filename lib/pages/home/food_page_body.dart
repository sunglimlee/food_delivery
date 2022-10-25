import 'package:flutter/material.dart';
import 'package:food_delivery/controller/popular_product_controller.dart';
import 'package:food_delivery/model/products_model.dart';
import 'package:food_delivery/pages/food/popular_food_detail.dart';
import 'package:food_delivery/pages/home/main_food_page.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/App_Column.dart';
import 'package:food_delivery/widget/big_text.dart';
import 'package:food_delivery/widget/icon_and_text.dart';
import 'package:food_delivery/widget/small_text.dart';
import 'package:get/get.dart';
import 'package:transparent_image/transparent_image.dart';

/*
/// 페이지뷰를 이렇게 독립적으로 만들어서 나중에 끼워 넣는 방식으로 사용한다.
/// 아주 좋은 방법인것 같다.
 */
typedef double2VoidFunc = void Function();

class FoodPageBody extends StatefulWidget {
  final double2VoidFunc callbackForCurrPageValue;
  final PagesValuesToShare pagesValuesToShare;

  const FoodPageBody(
      {Key? key,
      required this.pagesValuesToShare,
      required this.callbackForCurrPageValue})
      : super(key: key);

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  final double _scaleFactor = 0.8;
  final double _height = Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();
    // 내가 PageController 가 움직일때 값을 받아오기 위해서 Listener 를 연결해주어야 한다.
    pageController.addListener(() {
      setState(() {
        widget.pagesValuesToShare.currPageValue =
            pageController.page!; // 숫자가 0.0 - 1.0 까지 값이 변경되고 있네. page 값으로.. !!!
        widget.callbackForCurrPageValue();
        print(
            'Current value is ${widget.pagesValuesToShare.currPageValue.toString()}');
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
    return GetBuilder<PopularProductController>(
      builder: (popularProducts) { // update() 로 변경이 일어날때 마다 GetBuilder 가 실행되고 동시에 변경이 일어난 컨트롤러를 사용할 수 있게 된다.
        // dot indicator 에 값을 넣어주는 부분, class 객체로 데이터를 공유하고 있다.
        widget.pagesValuesToShare.pagesTotalValue =
            popularProducts.popularProductList.length;
        return Container(
          height: Dimensions.pageView,
          child: PageView.builder(
              controller: pageController,
              itemCount: popularProducts.popularProductList.length,
              itemBuilder: (context, position) {
                return _PageViewBuilderItem(
                    position, popularProducts.popularProductList[position]);
              }),
        );
      },
    );
  }

  Widget _PageViewBuilderItem(int position, ProductModel popularProduct) {
    Matrix4 matrix4 = Matrix4.identity();
    if (position == widget.pagesValuesToShare.currPageValue.floor()) {
      var currScale = 1 -
          (widget.pagesValuesToShare.currPageValue - position) *
              (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (position ==
        widget.pagesValuesToShare.currPageValue.floor() + 1) {
      var currScale = _scaleFactor +
          (widget.pagesValuesToShare.currPageValue - position + 1) *
              (1 - _scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1);
      matrix4 = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (position ==
        widget.pagesValuesToShare.currPageValue.floor() - 1) {
      var currScale = 1 -
          (widget.pagesValuesToShare.currPageValue - position) *
              (1 - _scaleFactor);
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
      child: GestureDetector(
        onTap: () {
          print('popular food 로 전달된 pageId 값은 $position 입니다.');
          Get.toNamed(RouteHelper.getPopularFood(position, RouteHelper.initial)); // 디테일 페이지로 이동
        },
        child: Stack(
          children: [
            _mainBody(position, popularProduct),
            _subBody(popularProduct),
          ],
        ),
      ),
    );
  }

  Widget _subBody(ProductModel popularProduct) {
    // 옆에 패딩을 넣어주기 위해서 Container 를 또 넣어주기로 했지..
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: Dimensions.pageViewTextContainer,
        margin: EdgeInsets.only(
            left: Dimensions.edgeInsets30,
            right: Dimensions.edgeInsets30,
            bottom: Dimensions.edgeInsets30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius30),
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
        child: AppColumn(title: popularProduct.name!),
      ),
    );
  }

  Widget _mainBody(int position, ProductModel popularProduct) {
    return Container(
      height: _height,
      margin: EdgeInsets.only(
          left: Dimensions.edgeInsets10, right: Dimensions.edgeInsets10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius30),
        //color: position.isEven ? Colors.green : Colors.pink,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            //const AssetImage('assets/images/loading.png'),
            image:
                '${AppConstants.BASE_URL}${AppConstants.UPLOAD_URL}${popularProduct.img}',
          ).image,
        ),
      ),
    );
  }
}

/*
Widget _mainBody(int position, ProductModel popularProduct) {
  return Container(
      height: _height,
      margin: EdgeInsets.only(
          left: Dimensions.edgeInsets10, right: Dimensions.edgeInsets10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius30),
        //color: position.isEven ? Colors.green : Colors.pink,
        image: DecorationImage(
            image:NetworkImage(
                AppConstants.BASE_URL + '/uploads/' + popularProduct.img.toString()),
            fit: BoxFit.cover),
      ));
}
*/
