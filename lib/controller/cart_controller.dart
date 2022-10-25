import 'package:flutter/material.dart';
import 'package:food_delivery/data/repository/cart_repo.dart';
import 'package:food_delivery/model/cart_model.dart';
import 'package:food_delivery/model/products_model.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:get/get.dart';

// Shopping Cart 를 위한 Controller
// 뭘 이렇게 정신없이 디테일 페이지로 들어가면 기존에 카트에 수량을 추가하는 작업도 하고 그러냐? 그냥 추가하면 추가하였다고 메세지 보내고 그리고 0으로 quantity 를 초기화를 하는거지..
// 값을 수정하고 싶으면 카트로 가서 수정해 그러면 된다.
// 그래서 여기 cart_controller 의 함수들과 그리고 popular_product_controller 의 함수들의 대부분 의미가 없게 되었다.
class CartController extends GetxController {
  final CartRepo cartRepo;

  CartController({required this.cartRepo});

  Map<int, CartModel> _items = {}; // 여기 맵을 이용해서 데이터를 다 저장하고..
  Map<int, CartModel> get items => _items;

  // 맵에 넣는 함수
  // addItem 함수를 이용해서 UI 에서 추가 버턴을 클릭하면 다시 Controller 가 추가를 하라는 명령을 CartRepo 에 내려준다.
  // 추가를 하기위해서 당연히 ProductModel 과 quantity 가 들어와야 하고.
  // 이제 이 함수에서 putIfAbasent 를 사용하는데 값이 없을 경우에만 추가를 해준다. 어떤 값으로 비교하냐고? product.id! 로 비교한다.
  // 그래서 그안에서 CartModel 을 만들어서 맵에다가 넣어주게 되는거다.
  void addItem(ProductModel product, int quantity) {
    // 만약 기존에 id 값이 존재하고 있다면 거기에다가 quantity 를 추가해주어야 한다.
    if (_items.containsKey(product.id!)) {
      _items.update(product.id!, (value) {
        return CartModel(
            id: value.id!,
            name: value.name!,
            price: value.price,
            img: value.img,
            quantity: value.quantity! + quantity,
            // 맞는 말이네.. 기존에 있는건 그대로 두고 거기에 추가로 더하는 거니깐.
            isExit: true,
            time: DateTime.now().toString());
      });
    } else {
      if (quantity > 0) {
        print("length of the item is ${_items.length.toString()}");
        // 중복된 자료가 들어가는 걸 방지하기 위해서
        _items.putIfAbsent(product.id!, () {
          print(
              "adding item to the cart ${product.id!.toString()}. quantity $quantity");
          // 데이터가 값이 이미 존재하면 추가가 되지 않는 문제를 해결한다. 순저히 Map 함수에 의존하는 거다.
          _items.forEach((key, value) {
            print("quantity is ${value.quantity.toString()}");
          });
          return CartModel(
              id: product.id,
              name: product.name!,
              price: product.price,
              img: product.img,
              quantity: quantity,
              isExit: true,
              time: DateTime.now().toString());
        });
      } else {
        Get.snackbar(
            "Item Count", "You should at least add an item in the cart",
            backgroundColor: AppColors.mainColor, colorText: Colors.black);
      }
    }
  }

  // 서버에서 받아온 ProductModel.id 와 Map 안에 들어있는 CartModel.id 가 같은게 있는지 확인해서 들어갈 때 그 값을 보여주고 add, remove 를 해주도록 한다. 그게 제일 맞는것 같다.
  bool existInCart(ProductModel product) {
    if (_items.containsKey(product.id!)) {
      // 맵에 값이 있는지 확인해서 true, false
      return true;
    }
    return false;
  }

  // 그래서 맵에 값이 있다면 그 값을 받아오는 함수.
  // 여기서도 잘봐라.. 로컬변수를 초기화 하고 그값을 조건문에서 바꾸고 나서 맨마지막에 로컬값을 리턴을 해준다. 아주 중요한 내용이다.
  int getQuantity(ProductModel product) {
    var quantity = 0; // 수량을 저장할 임시 로컬값.
    if (_items.containsKey(product.id!)) {
      _items.forEach((key, value) {
        // 맵을 한바퀴 돌리면서
        if (key == product.id) {
          // 키값이 같은게 있는지 확인한 후
          print("in carat_controller. ${value.quantity}");
          quantity = value.quantity!;
        }
      });
    }
    return quantity;
  }

  // 전체적인 총 갯수를 구하는 건가? 왜?
  int get totalItems {
    var totalQuantity = 0;
    _items.forEach((key, value) {
      totalQuantity += value
          .quantity!; // totalQuantity = totalQuantity + value.quantity!; 같은 뜻이다.
    });

    return totalQuantity;
  }
}
