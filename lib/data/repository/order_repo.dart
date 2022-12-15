import 'package:food_delivery/data/api/api_client.dart';
import 'package:food_delivery/model/place_order_model.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:get/get.dart';

class OrderRepo {
  final ApiClient apiClient;
  OrderRepo({required this.apiClient});

  Future<Response> placeOrder(PlaceOrderModel placeOrderModel) async {
    // 이제 계속 넘겨 받은 PlaceOrderModel 를 서버에 다시 넘겨준다.
    // 그러면 서버에서 받은 값을 가지고 데이터를 입력한 후에 response 를 넘겨주겠지.. 당연히 Http 로 넘겨주니깐 주소값이 있어야 하는거고..
    return await apiClient.postData(AppConstants.PLACE_ORDER_URI, placeOrderModel.toJson());
  }

  Future<Response> getOrderList() async {
    return await apiClient.getData(AppConstants.ORDER_LIST_URI);
  }
}