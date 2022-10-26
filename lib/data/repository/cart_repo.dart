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
  List<String> cart = [];

  CartRepo(this.shardPreferences); // 리스트를 사용한 이유는?

  void addToCartList(List<CartModel> cartList) { // 이함수를 실행시킨다는 말은 이 CartRepo 객체가 존재한다는 거지..
    // CartModel object 를 string 으로 넣는다?
    cart = [];
    /*
      convert object to string because sharedPreferences only accepts string
     */
    cartList.forEach((element) {
      //print('in Cart_repo. element 의 값은 ${element.toJson()}');
      return cart.add(jsonEncode(element)); // json 형태로 객체를 바꾸어서 리스트에 저장한다. 왜냐면 SharedPreferences 는 오직 String 만 받으니깐....
    });
    shardPreferences.setStringList(AppConstants.CART_LIST, cart); // Cart-list 라는 이름으로 SharedPreferences 안에 List 를 통째로 저장한다
    print('in Cart_repo. sharedPreferences 의 값은 ${shardPreferences.getStringList(AppConstants.CART_LIST)}'); // 저장이 안되었는데 오타때문이었슴.. ㅠㅠ
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
      cartList.add(CartModel.fromJson(jsonDecode(element)));  // 딱 한가지를 놓쳤다. 무조건 스트링으로 되어 있는걸 jsonDecode 를 통해서 Map 으로 바꾸었고 그걸 다시 fromJson 으로 객체로 바꾸었다.
    });

    return cartList;
  }
}
