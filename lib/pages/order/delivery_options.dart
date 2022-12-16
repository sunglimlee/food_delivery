import 'package:flutter/material.dart';
import 'package:food_delivery/controller/order_controller.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widget/style.dart';
import 'package:get/get.dart';

class DeliveryOptions extends StatelessWidget {
  final String value;
  final String title;
  final double amount;
  final bool isFree; // 내부에서 사용하는 거라서..

  const DeliveryOptions(
      {Key? key,
      required this.value,
      required this.title,
      required this.amount,
      required this.isFree})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      return Row(
        children: [
          // 이거 처음 사용하는거네... groupValue 와 value 가 같으면 selected 가 되는거구나.
          Radio(
            value: value,
            groupValue: orderController.orderType,
            onChanged: (value) {
              orderController.setDeliveryType(value!);
            },
            activeColor: Theme.of(context).primaryColor,
          ),
          SizedBox(
            width: Dimensions.edgeInsets10 / 2,
          ),
          Text(
            title,
            style: robotoRegular,
          ),
          SizedBox(
            width: Dimensions.edgeInsets10 / 2,
          ),
          Text(
            (value == 'takeout' || isFree)
                ? 'free'
                : '\$${amount / AppConstants.DELIVERY_CHARGE_PERCENTAGE}',
            style: robotoMedium,
          ),
        ],
      );
    });
  }
}
