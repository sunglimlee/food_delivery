import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/readmore_conversion.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/App_Column.dart';
import 'package:food_delivery/widget/app_icon.dart';
import 'package:food_delivery/widget/big_text.dart';

class PopularFoodDetail extends StatefulWidget {
  const PopularFoodDetail({Key? key}) : super(key: key);

  @override
  State<PopularFoodDetail> createState() => _PopularFoodDetailState();
}

class _PopularFoodDetailState extends State<PopularFoodDetail> {
  // 정말 관건은 Positioned 을 사용하지 말자.
  @override
  Widget build(BuildContext context) {
    ReadMoreTextConversion readMoreTextConversion = ReadMoreTextConversion(
      'Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.',
      trimLines: 3,
      colorClickableText: Colors.pink,
      trimMode: TrimModeC.Line,
      trimCollapsedText: 'Show more',
      trimExpandedText: 'Show less',
      style: TextStyle(
        height: 1.5,
        color: Colors.black45,
        fontSize: Dimensions.font20,
      ),
      moreStyle: TextStyle(
        color: Colors.red[300],
        fontSize: Dimensions.font16,
        fontWeight: FontWeight.bold,
      ),
      lessStyle: TextStyle(
        color: Colors.red[300],
        fontSize: Dimensions.font16,
        fontWeight: FontWeight.bold,
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            //Top Popular food detail image
            Container(
              margin: EdgeInsets.only(left: 0, right: 0),
              // 가로 세로를 반드시 정해주어야 하고.. 여기서는 height 에 맞춘다
              width: double.maxFinite,
              height: Dimensions.popularFoodImgSize,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://thumb.zumst.com/640x480/https://static.hubzum.zumst.com/hubzum/2020/04/03/09/b051210b4f8c462a91e03ee029e036a0.jpg'),
                      fit: BoxFit.cover)),
            ),
            // back & shopping cart icon button
            Container(
              margin: EdgeInsets.only(
                top: Dimensions.height45,
                left: Dimensions.edgeInsets20,
                right: Dimensions.edgeInsets20,
              ),
              //height: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  AppIcon(icon: Icons.arrow_back),
                  AppIcon(icon: Icons.shopping_cart_outlined)
                ],
              ),
            ),
            // popular food description
            Container(
              margin: EdgeInsets.only(
                left: Dimensions.edgeInsets20,
                right: Dimensions.edgeInsets20,
                top: Dimensions.popularFoodImgSize - Dimensions.edgeInsets20,
              ),
              //height: 1500, // 높이?????
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppColumn(
                    title: 'JJajang Sauce, Egg with Rice',
                  ),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: Dimensions.edgeInsets10),
                      child: BigText(
                        text: 'Introduce',
                      )),
                  InkWell(
                    onTap: () {
                      setState(() {});
                    },
                    child: readMoreTextConversion,
                  ),
                  SizedBox(
                    height: Dimensions.height45,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // 가로모드일 때 생각해봐라. 너무 크다. TODO
      bottomNavigationBar: Container(
        height: Dimensions.bottomeNavigationBarHeight,
        padding: EdgeInsets.only(
/*
              top: Dimensions.edgeInsets30,
              bottom: Dimensions.edgeInsets30,
*/
            left: Dimensions.edgeInsets20,
            right: Dimensions.edgeInsets20),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Colors.pink,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimensions.radius20),
              topRight: Radius.circular(Dimensions.radius20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.edgeInsets20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.remove,
                    color: AppColors.signColor,
                  ),
                  SizedBox(
                    width: Dimensions.height10,
                  ),
                  BigText(
                    text: '0',
                    color: Colors.black45,
                  ),
                  SizedBox(
                    width: Dimensions.height10,
                  ),
                  const Icon(
                    Icons.add,
                    color: AppColors.signColor,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(Dimensions.edgeInsets20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.green[200]),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BigText(
                    text: '\$0.08',
                    color: Colors.black45,
                  ),
                  SizedBox(
                    width: Dimensions.height20,
                  ),
                  BigText(
                    text: 'Add to Cart',
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
