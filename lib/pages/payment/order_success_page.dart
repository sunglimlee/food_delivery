import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_button.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';

class OrderSuccessPage extends StatelessWidget {
  final String orderId;
  final int status;

  const OrderSuccessPage(
      {Key? key, required this.orderId, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (status == 0) {
      Future.delayed(const Duration(seconds: 1), () {
        // Get.dialog(PaymentFailedDialog(orderId: orderId), barrierDismissible: false);
      });
    }
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: Dimensions.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(status == 1 ? Icons.check_circle_outline_outlined : Icons.warning_amber_outlined, size: 100, color: AppColors.mainColor,),
              SizedBox(
                height: Dimensions.height30,
              ),
              Text(
                status == 1
                    ? 'You placed the order successfully'
                    : 'Your order failed',
                style: TextStyle(fontSize: Dimensions.font20),
              ),
              SizedBox(
                height: Dimensions.height20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.height20,
                    vertical: Dimensions.height10),
                child: Text(
                  status == 1 ? 'Successful order' : 'Failed order',
                  style: TextStyle(
                      fontSize: Dimensions.font20,
                      color: Theme.of(context).disabledColor),
                  textAlign: TextAlign.center,
                ),
              ),
              // 문득 든 생각인데 사실 객체를 생성해서 바로 던져주고 있다. 이걸 만약에 나중에 사용하겠다면 변수에 등록해서 넘겨주지만 이건 그럴필요가없지.
              SizedBox(
                height: Dimensions.height10,
              ),
              Padding(
                padding: EdgeInsets.all(Dimensions.height20),
                child: CustomButton(
                  buttonText: 'Back to Home',
                  onPressed: () => Get.offNamed(RouteHelper.getInitial()),
                ),
              ),
              SizedBox(
                height: Dimensions.height10,
              ),
              // 여기 밑에 더 있을 거 같은데.... TODO
            ],
          ),
        ),
      ),
    );
  }
}
