import 'package:food_delivery/model/cart_model.dart';

class PlaceOrderModel {
  List<CartModel>? _cart; // 여기처럼 private 하게 선언하였고
  late double _orderAmount;
  late String _orderNote;
  late String _orderType;
  late String _paymentMethod;
  late double _distance;
  late String _address;
  late String _latitude;
  late String _longitude;
  late String _contactPersonName;
  late String _contactPersonNumber;

  PlaceOrderModel(
      {required cart, // required 사용했고, option 도 사용했고,
      required orderAmount,
      required orderNote,
      required orderType,
      required paymentMethod,
      required distance,
      required address,
      required latitude,
      required longitude,
      required contactPersonName,
      required contactPersonNumber}) {
    _cart = cart; // 여기에서 외부값을 필드에 초기화를 해주었고
    _orderNote = orderNote;
    _orderType = _orderType;
    _paymentMethod = _paymentMethod;
    _orderAmount = _orderAmount;
    _distance = distance;
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
    _contactPersonName = contactPersonName;
    _contactPersonNumber = contactPersonNumber;
  }

  List<CartModel> get cart =>
      _cart!; // 이렇게 getter 도 만들었고, maybe setter 도 만들어야 하지 않았을까 싶다.
  double get orderAmount => _orderAmount;

  String get orderNote => _orderNote;

  String get orderType => _orderType;

  String get paymentMethod => _paymentMethod;

  String get contactPersonNumber => _contactPersonNumber;

  String get contactPersonName => _contactPersonName;

  String get longitude => _longitude;

  String get latitude => _latitude;

  String get address => _address;

  double get distance => _distance;

  PlaceOrderModel.fromJson(Map<String, dynamic> json) {
    // fromJson 만들었고
    // 그안에 들어있는 배열을 이렇게 forEach 를 이용해서 객체화해서 변수에 넣는구나.
    if (json['cart'] != null) {
      List<CartModel> cart = []; // 초기화를 시키고
      // 맵안의 각각의 멤버들을 가지고 나눈거고
      json['cart'].forEach((v) {
        // 당연히 forEach 를 사용해야지.. 왜냐면 이미 객체이니깐.
        // 왜 에러가 나는지 모르겠다. question: The method 'add' can't be unconditionally invoked because the receiver can be 'null'.
        // 여기 잘 읽어보면 receiver 라고 하잖아!. 그건 cart 를 말하는거고 그 cart 를 잘 보면 그냥 cart = []; 라고 초기화를 했다. 이렇게 초기화를 하면
        // List<CartModel>? cart = []; 라고 하는것과 똑같은 효과가 생긴다. 그렇기에 나중에 이걸 사용하려면 그게 null 이 아니라는 걸 확실하게 정의 해서
        // cart!.add(CartModel.fromJson(v)); 라고 한것이다. 만약에 이렇게 한게 모호하다면 확실하게 맨처음에 선언시에 List<CartModel> cart = []; 라고 하면
        // 처음부터 null 이 아니라는걸 명확하게 해주게 되는것이다.
        cart.add(CartModel.fromJson(v));
      });
    }
    _orderAmount = json['order_amount'];
    _orderNote = json['order_note'];
    _orderType = json['order_type'];
    _paymentMethod = json['payment_method'];
    _distance = json['distance'];
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _contactPersonNumber = json['contact_person_number'];
    _contactPersonName = json['contact_person_name'];
  }

  Map<String, dynamic> toJson() {
    // 당연히 toJson, toList, Map 3개를 한꺼번에 사용해야지.. 그래야지 Json 객체로 넘어가지..
    final Map<String, dynamic> data =
        <String, dynamic>{}; // 대괄호만 써도 되는데 앞에 형을 붙여줬네..
    if (_cart != null) {
      data['cart'] = _cart!
          .map((v) => v.toJson())
          .toList(); // v.toJson 하나를 맵으로 바꾸고 그걸 toList 해서 다시 맵으로 바꾼거다.
    }
    data['order_amount'] = _orderAmount;
    data['order_note'] = _orderNote;
    data['order_type'] = _orderType;
    data['payment_method'] = _paymentMethod;
    data['distance'] = _distance;
    data['address'] = _address;
    data['longitude'] = _longitude;
    data['latitude'] = _latitude;
    data['contact_person_name'] = _contactPersonName;
    data['contact_person_number'] = _contactPersonNumber;
    return data;
  }
}
