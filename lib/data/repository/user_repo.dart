import 'package:food_delivery/data/api/api_client.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:get/get.dart';

// 자 다시 확실하게 하자. UserModel 을 만들었고 지금 controller 와 repo 를 또 다시 다 만드는데 이유가 뭔지..
// Model 별로 나누니깐 좋기는 하다.
class UserRepo { // 여기봐라. 여기 Repository 는 아무것도 상속하지 않았다.
  final ApiClient apiClient;

  UserRepo({required this.apiClient});

  Future<Response> getUserInfo() async {
    return await apiClient.getData(AppConstants.USER_INFO_URI);
  }
}