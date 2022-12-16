import 'package:flutter/material.dart';
import 'package:food_delivery/controller/order_controller.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/style.dart';
import 'package:get/get.dart';

class PaymentOptionButton extends StatelessWidget {
  final IconData iconData;
  final String title;
  final String subTitle;

  /// 이건 뭘 뜻하는거지?
  final int index;

  const PaymentOptionButton(
      {Key? key,
      required this.index,
      required this.iconData,
      required this.title,
      required this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      // _selected 를 이용해서 체크박스를 선택하도록 한다. 왜냐하면 다시 그려지니깐 그려질 때 값이 바뀌는 거지...
      bool _selected = orderController.paymentIndex == index;
      return InkWell(
        onTap: () {
          orderController.setPaymentIndex(index);
        },
        child: Container(
          padding: EdgeInsets.only(bottom: Dimensions.edgeInsets10 / 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radius20 / 4),
            color: Theme.of(Get.context!).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[200]!, blurRadius: 5, spreadRadius: 1),
            ],
          ),
          child: ListTile(
              leading: Icon(
                Icons.payment,
                size: 40,
                color: _selected
                    ? AppColors.mainColor
                    : Theme.of(context).disabledColor,
              ),
              title: Text(
                title,
                style: robotoMedium.copyWith(fontSize: Dimensions.font20),
              ),
              subtitle: Text(
                subTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: robotoMedium.copyWith(
                  fontSize: Dimensions.font16,
                  color: Theme.of(Get.context!).disabledColor,
                ),
              ),
              // 진짜 머리좋네.. option box 를 안만들고 getx variable 을 이용해서 그림에 보여주고 말지를 표현하는거네..
              trailing: _selected
                  ? Icon(iconData, color: Theme.of(Get.context!).primaryColor)
                  : const SizedBox.shrink()),
        ),
      );
    });
  }
}
