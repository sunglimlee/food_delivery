import 'dart:convert';
import 'dart:math';

import 'package:food_delivery/model/cart_model.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Shopping Cart 에 관련된 repository. Controller 가 있으면 Repo 가 반드시 같이 있어야 한다.
// repository 가 하는 역할은 데이터를 실제로 저장하고 하는 명령을 수행한다. 아마도 여기서는 SharedPreference 를 사용하는 것 같다.
class CartRepo extends GetxController {
  final SharedPreferences shardPreferences; // 나는 나중에 사용할 때 연결할 거다.

  // 히스토리를 로컬 SharedPreferences 에 넣어놓고 BottomNavigationBarItem 을 선택했을 때 그 히스토리를 보여주고 싶게 한다. (history)
  List<String> cart = []; // 결국은 전체값을 string 으로 저장해 놓은 거다. 순전히 카트와 관련된 변수 리스트이다.
  List<String> cartHistory = []; // 히스토리 페이지와 관련된 변수 리스트이다.


  CartRepo(this.shardPreferences); // 리스트를 사용한 이유는?

  void addToCartList(List<CartModel> cartList) { // 히스토리에 저장하기 위해서
    var time = DateTime.now().toString(); // 현재 시간을 설정해놓고
    // 이함수를 실행시킨다는 말은 이 CartRepo 객체가 존재한다는 거지..
    // CartModel object 를 string 으로 넣는다?
    // 카트를 새롭게 비워서 (디버깅 용도)
    //shardPreferences.remove((AppConstants.CART_LIST)); // 일단 로컬 스토리지에 있는 자료들을 싹 다 지우고나서...
    //shardPreferences.remove((AppConstants.CART_HISTORY_LIST)); // 일단 로컬 스토리지에 있는 히스토리자료들도 싹 다 지우고나서...
    cart = [];
    /*
      convert object to string because sharedPreferences only accepts string
     */
    cartList.forEach((element) {
      element.time = time; // 만약에 이렇게
      //print('in Cart_repo. element 의 값은 ${element.toJson()}');
      return cart.add(jsonEncode(element)); // json 형태로 객체를 바꾸어서 리스트에 저장한다. 왜냐면 SharedPreferences 는 오직 String 만 받으니깐....
    });
    shardPreferences.setStringList(AppConstants.CART_LIST, cart); // Cart-list 라는 이름으로 SharedPreferences 안에 List 를 통째로 저장한다
    print(
        'in Cart_repo. sharedPreferences 의 값은 ${shardPreferences.getStringList(AppConstants.CART_LIST)}'); // 저장이 안되었는데 오타때문이었슴.. ㅠㅠ
    //getCartList(); // 디버깅 용도
  }

  // 여기서 보면 분명히 List<String> 을 리턴한단말이야...
  // 헷갈린다면 여기처럼 로컬 변수를 각각 나누어서 작업하면 훨씬 쉽게 보인다.
  List<CartModel> getCartList() {
    List<String> carts = [];
    if (shardPreferences.containsKey(AppConstants.CART_LIST)) {
      carts = shardPreferences.getStringList(AppConstants.CART_LIST)!;
      print("in cart_repo. inside getCartList ${carts.toString()}");
    }
    List<CartModel> cartList = [];

    carts.forEach((element) {
      print("in Cart_repo. element 의 값은 ? ${element.toString()}");
      print(
          "in Cart_repo. JsonDecode 한 element 의 값은 ? ${jsonDecode(element.toString())}");
      print(
          "in Cart_repo. CartModel.fromJson(jsonDecode(element))) ${CartModel.fromJson(jsonDecode(element))}");
      cartList.add(CartModel.fromJson(jsonDecode(element))); // 딱 한가지를 놓쳤다. 무조건 스트링으로 되어 있는걸 jsonDecode 를 통해서 Map 으로 바꾸었고 그걸 다시 fromJson 으로 객체로 바꾸었다.
    });
    print("in cart_repo. cartList 의 값은 ? ${cartList}");
    return cartList;
  }
  // cart 값을 받아서
  void addToCartHistoryList() { // 기존에걸 불러서 계속 추가해 나간다는 거지..
    if (shardPreferences.containsKey(AppConstants.CART_HISTORY_LIST)) {
      cartHistory = shardPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }
    for (int i=0; i<cart.length; i++) {
      print("in Cart_repo. history list ${cart[i]}");
      cartHistory.add(cart[i]); // 기존 쇼핑 카트에 있는 데이터를 넣어주고.. 이미 cart 가 String 형태로 바뀌었기 때문에 그냥 추가만 시켜준거다.
    }
    removeCart();
    shardPreferences.setStringList(AppConstants.CART_HISTORY_LIST, cartHistory);
    print("The length of history list is ${getCartHistoryList().length.toString()}");
    for (CartModel i in getCartHistoryList()) {
      print("The time for the order is ${i.time}");
    }
  }

  void removeCart() {
    cart = []; // 왜 히스토리에 들어가면 cart 를 비워버리는 걸까? 체크아웃 후에 나중에 또 추가 할 수 도 있을 텐데..??? TODO
    shardPreferences.remove(AppConstants.CART_LIST);
  }
  
  List<CartModel> getCartHistoryList() {
    if (shardPreferences.containsKey(AppConstants.CART_HISTORY_LIST)) {
      //cartHistory = [];
      cartHistory = shardPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }
    List<CartModel> cartListHistory = [];
    for (String st in cartHistory) {
      cartListHistory.add(CartModel.fromJson(jsonDecode(st)));
    }
    //print("in Cart_repo. cartListHistory is ${cartListHistory.toString()}");
    return cartListHistory;
  }
}
