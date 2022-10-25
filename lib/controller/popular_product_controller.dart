import 'package:flutter/material.dart';
import 'package:food_delivery/controller/cart_controller.dart';
import 'package:food_delivery/data/repository/popular_product_repo.dart';
import 'package:food_delivery/model/products_model.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:get/get.dart';

class PopularProductController extends GetxController {
   final PopularProductRepo popularProductRepo;
  // Shopping Cart 를 사용하기 위해서, final 로 해놓으면 생성자에서 받아서 써야 하는데 late 를 해놓으면 나중에 초기화를 하고 또 사용할 수 있다.
    late CartController _cart;

  List<ProductModel> get popularProductList => _popularProductList;

  PopularProductController({required this.popularProductRepo});

  List<ProductModel> _popularProductList = []; // 리스트 초기화를 시켰다.


  // 이미지 loading 대기 서클 넣기 위해서
  bool _isLoaded = false; // private 으로 만들고
  bool get isLoaded => _isLoaded;

  // Shopping cart 작업하면 사용한 실제 숫자.
  int _quantity = 0;
  int get quantity => _quantity;

  int _inCartItems = 0; // 카트 안에 몇개의 아이템이 있는지 체크
  int get inCartItems => _inCartItems + _quantity;

  Future<void> getPopularProductList() async {
    Response response = await popularProductRepo.getPopularProductList();
    if (response.statusCode == 200) {
      // 성공했다면 successful
      print('데이터 가져오기 성공했슴. [in popular Controller]');
      _popularProductList =
          []; // 실행할 때마다 초기화를 시켜주어야 한다. 그래야 데이터가 반복해서 들어가는걸 방지할 수 있다. 상태가 유지되고 있으므로
      // 잘기억해라.. 이제 여기서 데이터를 실제로 사용할 거기 때문에 모델로 바꾸어주어야 한다는거지..
      // 인터넷에서 받은 json 데이터를 Map 과의 연관성은 어떻게 되냐는거지?????

      //
      _popularProductList.addAll(Product.fromJson(response.body)
          .products); // json 을 Model 로 변환해서 넣어주었슴.
      print("$_popularProductList in popular Controller");
      _isLoaded = true;
      update(); // setState 를 실행시킨다.
    } else {
      print('popularProductController  데이터 가져오기 실패했슴 ${response.statusCode}');
    }
  }

  // Shopping Cart 에 관련된 내용을 시작하며 수량을 입력하는 변수를 설정한다. 근데 이걸 증가 감소 true, false 이렇게 접근하고 있다.
  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity <
           20 ?  ++_quantity : Get.snackbar("Item Count", "You can't add more than 20 items.", backgroundColor: AppColors.mainColor, colorText: Colors.black);
      print('popular product controller 에서 현재 수량은 $_quantity');
    } else {
      _quantity <= 0 ? 0 :  --_quantity;
      print('popular product controller 에서 현재 수량은 : $_quantity');
    }
    update();
  }
  checkQuantity(int quantity) {} // 위에 방식대로 나만의 방식으로 사용해서 이 함수는 필요가 없다.

  void initProduct(ProductModel product, CartController cart) { // 매번 페이지에 들어갈 때 마다 새롭게 _quantity를 초기화 한다는 거지..
    _quantity = 0; // 당연히 초기화를 시켜줘야지.
    _inCartItems = 0; // 매번 새롭게 찾기 위해서인가?
    _cart=cart; // 참 희한하게 CartController 를 받는다.
    var exist = false; // 전부 초기화를 하네. 카트에 사용될 맵에 기존 product 가 존재하는지 확인

    exist = _cart.existInCart(product);
    // if exist
    // get from storage _inCartItems.
    print(" in popular_product_controller ${exist.toString()}");
    if (exist) {
      _inCartItems = _cart.getQuantity(product);
      //_quantity = _inCartItems; // 내생각에는 여기에 값을 넣어놯야 한다.
    }
    //print(" in popular_product_controller. the quantity in the cart is ${_inCartItems.toString()}");
  }

  // Map 에다가 값을 넣어준디
  void addItem(ProductModel product) {
    if (_quantity > 0) {
      _cart.addItem(product, _quantity);
      Get.snackbar("Thank you for purchasing", "We added your item(s) in the Cart.", backgroundColor: AppColors.mainColor, colorText: Colors.blue);
      _quantity = 0; // _quantity 를 0 으로 해주는 이유는 추가되었는데 만약 또 추가를 한다면 거기에 대한 추가 값이 들어가야 하기 때문이다. 안해주면 그 디테일 화면에서 계속 추가가 된다. 7 더했는데 1개 들려 8이 되었는데 맵에는 15가 더해지기 때문이지.
      //_inCartItems = _cart.getQuantity(product); // 값을 넣어주고 나서 _inCartItems 에 값을 다시 넣어준다.
      // 만약에 비디오에 나오는 것처럼 하고 싶으면 이 함수의 첫부분인 조건문을 없애준다.
      _cart.items.forEach((key, value) {
        print("The id is ${value.id.toString()}. The quantity is ${value.quantity}");
      });
    } else {
      Get.snackbar("Item Count", "You should at least add an item in the cart", backgroundColor: AppColors.mainColor, colorText: Colors.black);
    }
    update();
  }
}
