import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_loader.dart';
import 'package:food_delivery/controller/order_controller.dart';
import 'package:food_delivery/model/order_model.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/style.dart';
import 'package:get/get.dart';

class ViewOrder extends StatelessWidget {
  final bool isCurrent;

  const ViewOrder({Key? key, required this.isCurrent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OrderController>(builder: (orderController) {
        if (orderController.isLoading == false) {
          // 로딩이 끝났다는 뜻
          late List<OrderModel> orderList;
          if (orderController.currentOrderList.isNotEmpty) {
            // 나오는값이 Iterable 이므로 toList() 로 바꿔야 함
            // 가독성은 정말 않좋다. 이게 뭐니? 모르는 사람은 전혀 이해 못할 문장이잖아.
            orderList = isCurrent
                ? orderController.currentOrderList.reversed.toList()
                : orderController.historyOrderList.reversed.toList();
          }
          return SizedBox(
            width: Dimensions.screenWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.edgeInsets10 / 2,
                  vertical: Dimensions.edgeInsets10 / 2),
              child: ListView.builder(
                  itemCount: orderList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => null,
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Order ID",
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.font16),
                                    ),
                                    SizedBox(
                                      width: Dimensions.edgeInsets10 / 2,
                                    ),
                                    Text("${orderList[index].id.toString()}"),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.mainColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radius20 / 4),
                                        ),
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                Dimensions.radius20 / 4,
                                                vertical:
                                                Dimensions.edgeInsets10 /
                                                    2),
                                            margin: EdgeInsets.all(
                                                Dimensions.height10 / 2),
                                            child: Text(
                                              '${orderList[index].orderStatus}',
                                              style: robotoMedium.copyWith(
                                                  fontSize: Dimensions.font12,
                                                  color: Theme
                                                      .of(context)
                                                      .cardColor),
                                            ))),
                                    SizedBox(height: Dimensions.height5),
                                    InkWell(
                                      onTap: () => null,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                            Dimensions.radius20 / 4,
                                            vertical:
                                            Dimensions.edgeInsets10 /
                                                2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.radius20 / 4),
                                        ),
                                        child: Row(children: [
                                          Icon(Icons.track_changes_outlined,
                                            size: 15, color: Theme
                                                .of(context)
                                                .primaryColor,),
                                          SizedBox(
                                            width: Dimensions.edgeInsets10 / 2,),
                                          Text('Track order',
                                            style: robotoMedium.copyWith(
                                                fontSize: Dimensions.font12,
                                                color: Theme
                                                    .of(context)
                                                    .primaryColor),),
                                          Container(
                                            margin: EdgeInsets.all(
                                                Dimensions.edgeInsets10 / 2),
                                            child: const Text("Tradck Order"),
                                          )
                                        ],),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.height10,
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          );
        } else {
          return const CustomLoader();
        }
      }),
    );
  }
}
