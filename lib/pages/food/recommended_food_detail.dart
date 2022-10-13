import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/utils/readmore_conversion.dart';
import 'package:food_delivery/widget/app_icon.dart';
import 'package:food_delivery/widget/big_text.dart';

class RecommendedFoodDetail extends StatelessWidget {
  const RecommendedFoodDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      // 텍스트의 배경색이 어디서 바뀌는지 봐라. Scaffold 에서 바뀌고 있다.
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 70,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                AppIcon(
                  icon: Icons.clear,
                ),
                AppIcon(icon: Icons.shopping_cart_outlined)
              ],
            ),
            pinned: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimensions.radius20),
                        topRight: Radius.circular(Dimensions.radius20)),
                    color: Colors.white),
                alignment: Alignment.center,
                //color: Colors.yellow[400],
                child: BigText(
                  text: 'JJaJang Soup with Egg and Fried Rice',
                  size: Dimensions.font20,
                ),
                width: double.maxFinite,
                padding: const EdgeInsets.only(top: 5, bottom: 10),
              ),
            ),
            expandedHeight: 300,
            backgroundColor: Colors.yellow,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                'https://thumb.zumst.com/640x480/https://static.hubzum.zumst.com/hubzum/2020/04/03/09/b051210b4f8c462a91e03ee029e036a0.jpg',
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Column(
            children: [
              Container(
                color: Colors.blue,
                margin: EdgeInsets.only(
                    left: Dimensions.edgeInsets20,
                    right: Dimensions.edgeInsets20),
                child: const ExpandableText(
                  'Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.Chicken marinated in a spiced yogurt s place in a large pot. then layered with fried onions (cheeky easy sub below!), fresh coriander/cilanto, then par boild water. You can make it with a 15 mins and save some for the next meal time. It is so delicious.',
                  expandText: ' show more\n',
                  collapseText: ' show less',
                  maxLines: 1,
                  linkColor: Colors.blue,
                ),
              ),
            ],
          )),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        // 이걸 적용함으로써 Column 의 최소한의 높이를 정한다. 만약 없다면 부모가 Scaffold 이므로 전체를 잡아먹도록 된다.
        children: [
          Container(
            margin: EdgeInsets.only(
                left: Dimensions.edgeInsets20 * 2.5,
                right: Dimensions.edgeInsets20 * 2.5,
                top: Dimensions.edgeInsets10,
                bottom: Dimensions.edgeInsets10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppIcon(
                  icon: Icons.remove,
                  backgroundColor: Colors.red,
                  iconSize: 35,
                ),
                BigText(
                    text: '\$12.88' + ' X ' + '0',
                    color: AppColors.mainBlackColor),
                const AppIcon(
                  icon: Icons.add,
                  backgroundColor: Colors.red,
                  iconSize: 25,
                ),
              ],
            ),
          ),
          Container(
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
          )
        ],
      ),
    );
  }
}
