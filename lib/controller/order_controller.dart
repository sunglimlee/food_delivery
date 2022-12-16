// order 하는데 여러가지 코드가 많이 들어가기 때문에 그래서 congroller 로 만든다. 그말은 여러가지 공유할 자료가 있다느거고 그걸 한군데로 묶어서 같이 관리하겠다는 거지.
// GetxService 를 사용하는 이유는 오랫동안 메모리에 남도록 하기 위해서이다.
import 'package:food_delivery/data/repository/order_repo.dart';
import 'package:food_delivery/model/order_model.dart';
import 'package:food_delivery/model/place_order_model.dart';
import 'package:get/get.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;

  OrderController(
      {required this.orderRepo}); // required 를 꼭 넣어주자. 상당히 편리한 부분이다.

  late List<OrderModel>
      _currentOrderList; // 히스토리를 다루고 있는데 여기서 currentOrderList 라고 하는 이유는 뭐지? 오케이 현재거와
  late List<OrderModel> _historyOrderList; // 히스토리꺼

  bool _isLoading = false; // 나중에 바꿀건데 왠 final???????? 할 필요없지..
  bool get isLoading => _isLoading;

  List<OrderModel> get currentOrderList => _currentOrderList;

  List<OrderModel> get historyOrderList => _historyOrderList;

  // payment 방법에 대해
  int _paymentIndex = 0; // cash 가 기본값임.
  int get paymentIndex => _paymentIndex;

  // delivery type 에 대해서
  String _orderType = 'delviery';

  String get orderType => _orderType;
  String _foodNote = '';

  String get foodNote => _foodNote;

  // 값을 받지만 여기까지 하고 리턴을 하지는 않을 거다. 그래서 Future<void> 를 해준다.
  Future<void> placeOrder(
      PlaceOrderModel placeOrderModel, Function callback) async {
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
      callback(true, message,
          orderId); // 현재페이지인데 under the hood 에서 계속 값이 전달되면 실행되고 있다는 것이다.
    } else {
      callback(false, response.statusText!, '-1');
    }
  }

  /// 오더 히스토리를 화면에 나타내기 위한 함수
  /// 항상 서버로부터 데이터를 받는다면(거의 json) 그 데이터를 모델로 바꾸어주는 작업을 반드시 하도록 하자. 그래야 편하다. 여기서는 order_model.dart
  Future<void> getOrderList() async {
    _isLoading = true; // 로딩시작하고
    update();
    Response response = await orderRepo.getOrderList();
    if (response.statusCode == 200) {
      _historyOrderList = []; // 맨처음에 항상 초기화 시키자.
      _currentOrderList = [];
      // 잘봐라. 바디에서 뭐가 날라올지 알고있잖아. 오더모델에 관련된 json 이 날라오는거지.
      response.body.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(
            order); // 이렇게 하나의 오더를 가지고 오더모델을 만들어야 한다. 항상 생가하자.
        // 여기중에 하나라면 오더가 스틸 processing 중이라는거다.
        if (orderModel.orderStatus == 'pending' ||
            orderModel.orderStatus == 'accepted' ||
            orderModel.orderStatus == 'processing' ||
            orderModel.orderStatus == 'handover' ||
            orderModel.orderStatus == 'picked_up') {
          _currentOrderList.add(
              orderModel); // 왜 나는 이런게 안떠오르는 걸까? 빈리스트를 만들었으니 당연히 add 를 할 수 있는 거잖아.
        } else {
          _historyOrderList.add(
              orderModel); // 위의 내용이 아니라면 그건 전부 히스토리에 저장되어야 한다. 그러니깐 화면이 탭을 통해 두개로 나뉜다는 거지.
        }
      });
    } else {
      _historyOrderList = [];
      _currentOrderList = [];
    }
    _isLoading = false;
    update(); // 맨마지막에 해주네..
  }

  // Payment 값을 넣기 위한 함수
  void setPaymentIndex(int index) {
    _paymentIndex = index;
    update(); // update 를 해주는 이유는 UI 에서 이값을 사용했을 때 변경된 값을 적용시키라는 의미이다.
  }

  // 너무나도 간단한 진리이다. 변수가지고 있고 그 변수를 바꾸는 함수가 있고 외부 ui 에서 함수로 값을 바꾸면 그함수가 다시 update 를 실행하도록 해서 ui 의 값을 해당 변수에 따라
  // 바궈준다.
  // Delivery Type
  void setDeliveryType(String type) {
    _orderType = type;
    update();
  }

  /// 옵션의 note 를 넎는 부분
  void setFoodOptionNote(String note) {
    _foodNote = note;
    //update();
  }
}
