import 'package:food_delivery/base/show_custom_snackbar.dart';
import 'package:food_delivery/routes/route_helper.dart';
import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) { // 유저가 로그인했는지 알아봐서.. 안했으면 즉 not validation yet
      Get.offNamed(RouteHelper.getSignInPage);
    } else {
      showCustomSnackBar(response.statusText!);
    }
  }
}