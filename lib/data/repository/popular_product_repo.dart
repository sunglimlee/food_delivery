import 'package:food_delivery/data/api/api_client.dart';
import 'package:get/get.dart';

// 인터넷 서비스를 이용하기 위해서 GetxService 를 상속받아야 한다.
class PopularProductRepo extends GetxService {
  final ApiClient apiClient;

  PopularProductRepo(
      {required this.apiClient}); // 외부에서 apiClient 를 받아와서 시행시켜주도록 한다.

  Future<Response> getPopularProductList() async {
    // 딱 보이지? 여기 Future<Response> 를 리턴한다고 해놨잖아.!
    // 보이지 간단하게 uri 만 더져주고 데이터를 실제로 받고 에러처리 하는 부분은 apiClient 에 의존한다.
    //return await apiClient.getData('http://127.0.0.1:8000/api/v1/products/popular');
    return await apiClient.getData('/api/v1/products/popular');
  }
}
