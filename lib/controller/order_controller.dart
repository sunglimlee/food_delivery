// order 하는데 여러가지 코드가 많이 들어가기 때문에 그래서 congroller 로 만든다. 그말은 여러가지 공유할 자료가 있다느거고 그걸 한군데로 묶어서 같이 관리하겠다는 거지.
// GetxService 를 사용하는 이유는 오랫동안 메모리에 남도록 하기 위해서이다.
import 'package:food_delivery/data/repository/order_repo.dart';
import 'package:food_delivery/model/place_order_model.dart';
import 'package:get/get.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;

  OrderController({required this.orderRepo}); // required 를 꼭 넣어주자. 상당히 편리한 부분이다.

  bool _isLoading = false; // 나중에 바꿀건데 왠 final???????? 할 필요없지..
  bool get isLoading => _isLoading;

  // 값을 받지만 여기까지 하고 리턴을 하지는 않을 거다. 그래서 Future<void> 를 해준다.
  Future<void> placeOrder(PlaceOrderModel placeOrderModel, Function callback) async {
    _isLoading = true; // 로딩을 시작한다.
    update(); // 이제 로딩화면을 띄워라.
    Response response = await orderRepo.placeOrder(placeOrderModel);
    // 콜백함수를 이용해서 여기서 받은 데이터를 UI 의 콜백함수로 값을 전달해서 그 UI 에서 계속 작업이 되도록 한다.
    if (response.statusCode == 200) {
      _isLoading = false; // 로딩이 끝났다.
      update(); // 로딩화면을 없애라.
      String message = response.body['message'];
      String orderId = response.body['order_id'].toString(); // 숫자이니깐 문자로..
      // 이렇게 여기서 나오는 값을 외부의 콜백함수에다가 넣어서 실행시켜준다. 그럼 제이권이 외부의 콜백함수로 넘어가는거지..
      // 왜 이게 중요하냐면 여기서 만든 결과값을 외부의 콜백함수가 사용하면서 외부의 모든 멤버값들을 가지고 계속 제어권도 가지고 실행할 수 있다는거지..
      callback(true, message,orderId); // 현재페이지인데 under the hood 에서 계속 값이 전달되면 실행되고 있다는 것이다.
    } else {
      callback(false, response.statusText!,'-1');
    }
  }
}